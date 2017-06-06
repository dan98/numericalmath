close all;
load('solarSimData.mat');

vec0 = reshape(velAndPos, 66, 1);
hF = @(t, x) (nBodyF(t, x, 11, bodyMass));

[trk, solrk] = odeSolveRK(hF, [0, 20], vec0, 4, 1/(365.2422));

tau = zeros(1, length(trk));

moon = 5;
earth = 4;
sun = 1;

for i=1:length(trk)
  xm = solrk(i, ((moon - 1)*6 + 4:1:(moon-1)*6 + 6));
  xe = solrk(i, ((earth - 1)*6 + 4:1:(earth-1)*6 + 6));
  xs = solrk(i, ((sun - 1)*6 + 4:1:(sun-1)*6 + 6));
  dme = xm - xe;
  dms = xm - xs;
  tau(i) = (dme * dms')/(norm(dme)*norm(dms));

  if(abs((tau(i) - 1))<3*10^(-4))
     disp(datestr(addtodate(datenum('00:00 1-Jan-2017'), i, 'hour'), 'HH:MM dddd dd mmmm yyyy'));
  end
end

figure;
plot(trk, tau);

%simulateSolarSystem(trk, solrk, bodyData);

simulateSolarSystem(trk, solrk, bodyData);
