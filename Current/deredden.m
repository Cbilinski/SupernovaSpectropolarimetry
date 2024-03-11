%%%dereddening based on the prescription of Cardelli, Clayton, and Mathis 1989 and O'Donnell 1994 revision
%http://articles.adsabs.harvard.edu/cgi-bin/nph-iarticle_query?1989ApJ...345..245C&amp;data_type=PDF_HIGH&amp;whole_paper=YES&amp;type=PRINTER&amp;filetype=.pdf
%http://articles.adsabs.harvard.edu/cgi-bin/nph-iarticle_query?1994ApJ...422..158O&amp;data_type=PDF_HIGH&amp;whole_paper=YES&amp;type=PRINTER&amp;filetype=.pdf
%Last updated 3-22-2015

function fluxdered = deredden(wavelength,flux,Av)  

%Obtain Av from the NED database or other source and read it in;

%Assume a ratio of the extinction to the reddening of 3.08 from CCM 1989 and calculate the reddening value;
%changed to using 3.1 on 2021-04-02 in line with the 1994 O'Donnell results
Rv = 3.1;
Ebv = Av / Rv;

%Calculate x, the inverse wavelength in microns, from a wavelength vector in Angstroms
x = zeros(length(wavelength),1);
x(:,1) = 10000./wavelength;
a = zeros(size(wavelength));
b = zeros(size(wavelength));

%Far ultraviolet range: 8-10 inverse micron section calculation
section = find((x >= 1.1) & (x <= 3.3));
y = x(section) - 1.82;
a(section) = -1.0783 - 0.628.*(x(section)-8) + 0.137*(x(section)-8).^2 - 0.070.*(x(section)-8).^3;
b(section) = 13.670 + 4.257.*(x(section)-8) - 0.420.*(x(section)-8).^2 + 0.374.*(x(section)-8).^3;

%Ultraviolet range: 3.3-8 inverse micron section calculation
section = find((x >= 3.3) & (x <= 8));
subsection = find((x >= 5.9) & (x <= 8));
Fa = zeros(length(x),1);
Fb = zeros(length(x),1);
Fa(subsection) = -0.04473.*(x(subsection)-5.9).^2-0.009779.*(x(subsection)-5.9).^3;
Fb(subsection) = 0.2130.*(x(subsection)-5.9).^2 + 0.1207.*(x(subsection)-5.9).^3;
a(section) = 1.752 - 0.316.*x(section) - 0.104./((x(section)-4.67).^2+0.341) + Fa(section);
b(section) = -3.090 + 1.825.*x(section) + 1.206./((x(section)-4.62).^2+0.263) + Fb(section);

%Optical/NIR range: 1.1-3.3 inverse micron section calculation (O'Donnell coefficients)
section = find((x >= 1.1) & (x <= 3.3));
y = x(section) - 1.82;
a(section) = 1 + 0.104*y - 0.609*y.^2 +0.701*y.^3 + 1.137*y.^4 - 1.718*y.^5 - 0.827*y.^6 + 1.647*y.^7 - 0.505*y.^8;
b(section) = 1.952*y + 2.908*y.^2 - 3.989*y.^3 - 7.985*y.^4 + 11.102*y.^5 +5.491*y.^6 - 10.805*y.^7 + 3.347*y.^8;

%CCM coefficients
%a(section) = 1 + 0.17699*y - 0.50447*y.^2 - 0.02427*y.^3 + 0.72085*y.^4 + 0.01979*y.^5 - 0.77530*y.^6 + 0.32999*y.^7;
%b(section) = 1.41338*y + 2.28305*y.^2 + 1.07233*y.^3 - 5.38434*y.^4 - 0.62251*y.^5 + 5.30260*y.^6 - 2.09002*y.^7;

%Infrared-Optical range: 0.3-1.1 inverse micron section calculation
section = find((x >= 0.3) & (x <= 1.1));
a(section) = 0.574*x(section).^(1.61);
b(section) = -0.527*x(section).^(1.61);

%Calculate the extinction in each wavelength range and then deredden the flux vector based on these extinction values;
Alambda = Av .* (a + b./Rv);
fluxdered = flux .* (10.^(0.4.*Alambda));

