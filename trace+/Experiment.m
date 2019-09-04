clc;

%-- initialization and data input part --%
% set total number of sample
N = size(ax1,1);
% set sampling period
dt = 0.01;
% set sampling time
T = 0:dt:N*dt-dt;
% set gravity
g = 9.81;
ax2 = zeros(N,1);
ay2 = zeros(N,1);
az2 = zeros(N,1);
wx2 = zeros(N,1);
wy2 = zeros(N,1);
wz2 = zeros(N,1);
roll2 = zeros(N,1);
pitch2 = zeros(N,1);
yaw2 = zeros(N,1);
% input measured acceleration, angular rate, attitude
measuredA = [ax1';ay1';az1';ax2';ay2';az2'] * g;
measuredW = [wx1';wy1';wz1';wx2';wy2';wz2'];
measuredAngle = [roll1';pitch1';yaw1';roll2';pitch2';yaw2'];

%--  trajectory reconstruction with normal kalman filter and MAUKF --%

% initialize state vector
% OS = (wx,wy,wz,q0,q1,q2,q3)
OS1 = zeros(7,N);
OS2 = zeros(7,N);
% PS = (p1x, v1x, a1x, p1y, v1y, a1y, p1z, v1z, a1z, p2x, v2x, a2x, p2y, v2y, a2y, p2z, v2z, a2z)
PS = zeros(18,N);
% set time constant for body angular velocity
tao1 = 0.5;
tao2 = 0.5;
tao3 = 0.5;
D1 = 0.4;
D2 = 0.4;
D3 = 0.4;
% set system input of orientation estimation
OB = 0;
Ou = [0,0,0,0,0,0,0]';
% set orientation measurement matrix
OC = eye(7);
% set orientation process noise covariance
OQ = diag([D1/2/tao1*(1-exp(-2*dt/tao1)), D2/2/tao2*(1-exp(-2*dt/tao2)), D3/2/tao3*(1-exp(-2*dt/tao3)), 0, 0, 0, 0]);
% set orientationmeasure noise covariance
OR = diag([0.01,0.01,0.01,0.0001,0.0001,0.0001,0.0001]);
% set orientation forcast error covariance
OP1 = 0.1 * eye(7);
OP2 = 0.1 * eye(7);
% set system input of position estimation
Pu = zeros(18,1);
PB = 0;
% set position process noise(m/s^2)
w = 0.02;
% set position measure noise(m/s^2)
z = 0.1;
% set position process noise covariance
PQ = w^2 .* diag([dt*dt,dt,1,dt*dt,dt,1,dt*dt,dt,1,dt*dt,dt,1,dt*dt,dt,1,dt*dt,dt,1]);
% set position measure noise covariance
PR = z^2 .* diag([1,1,1,1,1,1]);
% set position forcast error covariance
PP = 5 * diag([dt*dt,dt,1,dt*dt,dt,1,dt*dt,dt,1,dt*dt,dt,1,dt*dt,dt,1,dt*dt,dt,1]);
% initialize stop count
stopCount = zeros(6,1);

for i = 1 : N
    if i == 1      
        OS1(:,i) = [measuredW(1:3,i); EulerAngleToQuaternion(measuredAngle(1:3,i))];
        OS2(:,i) = [measuredW(4:6,i); EulerAngleToQuaternion(measuredAngle(4:6,i))];
    else
        % calculate orientation state transition matrix
        OA1 = calculateOrientationTransitionMatrix(OS1(:,i-1), tao1, tao2, tao3, dt);
        OA2 = calculateOrientationTransitionMatrix(OS2(:,i-1), tao1, tao2, tao3, dt);
        % set orientation state measurement matrix
        OC = eye(7);
        % do Kalman filter for orientation
        [OS1(:,i),OP1] = kalmanFilter(OS1(:,i-1), OP1, OA1, OB, Ou, OC, [measuredW(1:3,i);EulerAngleToQuaternion(measuredAngle(1:3,i))], OQ, OR);
        [OS2(:,i),OP2] = kalmanFilter(OS2(:,i-1), OP2, OA2, OB, Ou, OC, [measuredW(4:6,i);EulerAngleToQuaternion(measuredAngle(4:6,i))], OQ, OR);
        % renormalize quaternion
        OS1(4:7,i) = OS1(4:7,i)/(sqrt(sum(OS1(4:7,i) .* OS1(4:7,i))));
        OS2(4:7,i) = OS2(4:7,i)/(sqrt(sum(OS2(4:7,i) .* OS2(4:7,i))));
    end
    % calculate rotation matrix from quaternion
    C1 = QuaternionToRotationMatrix(OS1(4:7,i));
    C2 = QuaternionToRotationMatrix(OS2(4:7,i));
    if i == 1
        PS(:,i) = [-0.2, 0, measuredA(1,i), 0.3, 0, measuredA(2,i), 0, 0, measuredA(3,i), -0.4, 0, measuredA(4,i), 0.3, 0, measuredA(5,i), 0, 0, measuredA(6,i)]';
    else
        % calculate position state transiton matrix
        PA = [[1,dt,C1(1,1)*dt*dt/2,0,0,C1(1,2)*dt*dt/2,0,0,C1(1,3)*dt*dt/2; 0,1,C1(1,1)*dt,0,0,C1(1,2)*dt,0,0,C1(1,3)*dt; 0,0,1,0,0,0,0,0,0; ...
               0,0,C1(2,1)*dt*dt/2,1,dt,C1(2,2)*dt*dt/2,0,0,C1(2,3)*dt*dt/2; 0,0,C1(2,1)*dt,0,1,C1(2,2)*dt,0,0,C1(2,3)*dt; 0,0,0,0,0,1,0,0,0; ...
               0,0,C1(3,1)*dt*dt/2,0,0,C1(3,2)*dt*dt/2,1,dt,C1(3,3)*dt*dt/2; 0,0,C1(3,1)*dt,0,0,C1(3,2)*dt,0,1,C1(3,3)*dt; 0,0,0,0,0,0,0,0,1],zeros(9,9);...
              zeros(9,9), [1,dt,C2(1,1)*dt*dt/2,0,0,C2(1,2)*dt*dt/2,0,0,C2(1,3)*dt*dt/2; 0,1,C2(1,1)*dt,0,0,C2(1,2)*dt,0,0,C2(1,3)*dt; 0,0,1,0,0,0,0,0,0; ...
               0,0,C2(2,1)*dt*dt/2,1,dt,C2(2,2)*dt*dt/2,0,0,C2(2,3)*dt*dt/2; 0,0,C2(2,1)*dt,0,1,C2(2,2)*dt,0,0,C2(2,3)*dt; 0,0,0,0,0,1,0,0,0; ...
               0,0,C2(3,1)*dt*dt/2,0,0,C2(3,2)*dt*dt/2,1,dt,C2(3,3)*dt*dt/2; 0,0,C2(3,1)*dt,0,0,C2(3,2)*dt,0,1,C2(3,3)*dt; 0,0,0,0,0,0,0,0,1]
               ];
        % set position measurement matrix
        PC = [[0,0,1,0,0,0,0,0,0; 0,0,0,0,0,1,0,0,0; 0,0,0,0,0,0,0,0,1], zeros(3,9);...
             zeros(3,9), [0,0,1,0,0,0,0,0,0; 0,0,0,0,0,1,0,0,0; 0,0,0,0,0,0,0,0,1]];
        % do normal Kalman filter for position
        [PS(:,i),PP] = kalmanFilter(PS(:,i-1), PP, PA, PB, Pu, PC, measuredA(:,i), PQ, PR);
    end
    % calculate device acceleration to earth
    aToEarth = [C1 * measuredA(1:3,i);C2 * measuredA(4:6,i)];
    
    for j=1:size(aToEarth,1)
        if abs(aToEarth(j)) < 0.01 * g * 2
            stopCount(j) = stopCount(j)+1;
        else
            stopCount(j) = 0;
        end
        if stopCount(j) == 10
            PS(3*j-1,i) = 0;
            stopCount(j) = 0;
        end
    end
end

%-- consequence exhibitoin part --%
figure
plot(PS(1,:), PS(4,:),'b',PS(10,:),PS(13,:),'b');
xlabel('x/m');
ylabel('y/m');