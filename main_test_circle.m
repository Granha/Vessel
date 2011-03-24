%definitions des parametres
n = 128;     %taille de l'image
c=[40,64]; %centre du disque
R=4;   %rayon du disque

%creation de l'image synthetique avec un seul disque
Im=imsyn(n,c,R);  

%creation de l'image avec un rectangle
%l=20;w=2*R;
%Im=imrec(n,c,l,w);

%lire les image de jonction
% load Tjunc1;
% Im=Tjunc1(:,:,30);


image(Im); colormap(gray);  %l'affichage



rl=6; %rayon du disque LOCAL
tb = zeros(n,1);
Q=zeros(2,2);


%des filtres locaux
dim=25;
h11=conv2(b(n,rl),g11(dim),'same');
h22=conv2(b(n,rl),g22(dim),'same');

%images filtrees par des filtres locaux
% Imf11=imfilter(Im,h11,'conv');
% Imf22=imfilter(Im,h22,'conv');
Imf11=conv2(Im,h11,'same');
Imf22=conv2(Im,h22,'same');

%on parcourt la ligne [*,c(2)]
for i =1:n
    centre=[i,c(2)];  
    
    Q(1,1)=Imf11(centre(1),centre(2));
    Q(2,2)=Imf22(centre(1),centre(2));
    
    %la trace normalisee de Q
    tb(i)= (Q(1,1)+Q(2,2))/(2*3.14159*rl);
end

% Affichage de l'image test?e et des r?sultats
figure
subplot(1,2,1),image(Im); colormap(gray);
subplot(1,2,2),plot(tb); colormap(gray);

