% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%   Universidade Federal de São Carlos - Campus Sorocaba          %
%   Disciplina: Processamento de Imagens e Visão Computacional    %
%                                                                 %
%   Leandro Naidhig           726555                              %
%   Michele Argolo Carvalho   726573                              %
%                                                                 %
%   Adapatação do código: Optical Caracter Recognition (OCR)      %  
%   https://github.com/baumanta/OCR_octave                        %
%                                                                 %
%   Dependências Necessárias:                                     %
%   sudo apt-get install ocrad                                    %
%                                                                 %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Limpeza da area de trabalho e carregamento do pacote de imagem
clear all, close all, clc;
pkg load image; 

nota2   = imread('2.PNG');
nota5   = imread('5.PNG');
nota10  = imread('10.PNG');
nota20  = imread('20.PNG');
nota50  = imread('50.PNG');
nota100 = imread('100.PNG');

%Number

one=imread('letters_numbers/1.bmp');  two=imread('letters_numbers/2.bmp');
three=imread('letters_numbers/3.bmp');four=imread('letters_numbers/4.bmp');
five=imread('letters_numbers/5.bmp'); six=imread('letters_numbers/6.bmp');
seven=imread('letters_numbers/7.bmp');eight=imread('letters_numbers/8.bmp');
nine=imread('letters_numbers/9.bmp'); zero=imread('letters_numbers/0.bmp');

%*-*-*-*-*-*-*-*-*-*-*-

number=[one two three four five six seven eight nine zero];

character=[number];

global templates=mat2cell(character,42,[24 24 24 24 24 24 24 24 24 24]);

function [fl re]=lines(im_texto)

im_texto=clip(im_texto);
num_filas=size(im_texto,1);
for s=1:num_filas
    if sum(im_texto(s,:))==0
        nm=im_texto(1:s-1, :); 
        %pause(1);
        rm=im_texto(s:end, :);
        %pause(1);
        fl = clip(nm);
        pause(1);
        re=clip(rm);
       
        break
    else
        fl=im_texto;%Only one line.
        re=[ ];
    end
end
endfunction

function img_out=clip(img_in)
[f c]=find(img_in);
img_out=img_in(min(f):max(f),min(c):max(c));
endfunction

function letter=read_letter(imagn,num_letras)

global templates
comp=[ ];


 for n=1:num_letras
    
    sem=corr2(templates{1,n},imagn);
    comp=[comp sem];
    
    %pause(1)
end

vd=find(comp==max(comp));
%*-*-*-*-*-*-*-*-*-*-*-*-*-
if vd==1
    letter='1';
elseif vd==2
    letter='2';
elseif vd==3
    letter='3';
elseif vd==4
    letter='4';
elseif vd==5
    letter='5';
elseif vd==6
    letter='6';
elseif vd==7
    letter='7';
elseif vd==8
    letter='8';
elseif vd==9
    letter='9';
elseif vd==10
    letter='0';
elseif vd==11
    letter='K';
elseif vd==12
    letter='L';
elseif vd==13
    letter='M';
elseif vd==14
    letter='N';
elseif vd==15
    letter='O';
elseif vd==16
    letter='P';
elseif vd==17
    letter='Q';
elseif vd==18
    letter='R';
elseif vd==19
    letter='S';
elseif vd==20
    letter='T';
elseif vd==21
    letter='U';
elseif vd==22
    letter='V';
elseif vd==23
    letter='W';
elseif vd==24
    letter='X';
elseif vd==25
    letter='Y';
elseif vd==26
    letter='Z';
    %*-*-*-*-*
elseif vd==27
    letter='1';
elseif vd==28
    letter='2';
elseif vd==29
    letter='3';
elseif vd==30
    letter='4';
elseif vd==31
    letter='5';
elseif vd==32
    letter='6';
elseif vd==33
    letter='7';
elseif vd==34
    letter='8';
elseif vd==35
    letter='9';
elseif vd==36
    letter='0';
    %********
elseif vd==37
    letter='a';
elseif vd==38
    letter='b';
elseif vd==39
    letter='c';
elseif vd==40
    letter='d';
elseif vd==41
    letter='e';
elseif vd==42
    letter='f';
elseif vd==43
    letter='g';
elseif vd==44
    letter='h';
elseif vd==45
    letter='i';
elseif vd==46
    letter='j';
elseif vd==47
    letter='k';
elseif vd==48
    letter='l';
elseif vd==49
    letter='m';
elseif vd==50
    letter='n';
elseif vd==51
    letter='o';
elseif vd==52
    letter='p';
elseif vd==53
    letter='q';
elseif vd==54
    letter='r';
elseif vd==55
    letter='s';
elseif vd==56
    letter='t';
elseif vd==57
    letter='u';
elseif vd==58
    letter='v';
elseif vd==59
    letter='w';
elseif vd==60
    letter='x';
elseif vd==61
    letter='y';
elseif vd==62
    letter='z';
else
    letter='l';
    %*-*-*-*-*
end

endfunction

function reconheceCedula(nota, padrao)
  figure, imshow(nota);
  notaGray = imresize(rgb2gray(nota), [199 447]); 
  figure, imshow(notaGray);
  [lin col] = size(notaGray);

  x_ini = col - 100;

  teste = imcrop(notaGray, [x_ini, 1, 90, 70]);
  figure, imshow(teste);
  
  teste = imcrop(teste, [padrao, 13, 70, 48]);
  figure, imshow(teste);
  
  
  threshold = graythresh(teste);
  imagen =~im2bw(teste,threshold);
  figure, imshow(imagen);
  % Remove all object containing fewer than 30 pixels
  imagen = bwareaopen(imagen,30);
  %Storage matrix word from image
  word=[ ];
  re=imagen;
  %Opens text.txt as file for write
  fid = fopen('text.txt', 'wt');

global templates
% Compute the number of letters in template file
num_letras=size(templates,2);
while 1
    %Fcn 'lines' separate lines in text
    [fl re]=lines(re);
    imgn=fl;
    %Uncomment line below to see lines one by one
    %imshow(fl);pause(0.5)    
    %-----------------------------------------------------------------     
    % Label and count connected components
    [L Ne] = bwlabel(imgn);    
    for n=1:Ne
        [r,c] = find(L==n);
        % Extract letter
        n1=imgn(min(r):max(r),min(c):max(c));  
        % Resize letter (same size of template)
        img_r=imresize(n1,[42 24]);
        %Uncomment line below to see letters one by one
         %imshow(img_r);pause(0.5)
        %-------------------------------------------------------------------
        % Call fcn to convert image to text
        letter=read_letter(img_r,num_letras);
        % Letter concatenation
        word=[word letter];
    end
    
    if(word == '100') 
    
      disp('wtf');
      %fprintf(fid,'%s\n',lower(word));%Write 'word' in text file (lower)
      disp(word);
      fprintf(fid,'%s\n',word);%Write 'word' in text file (upper)
      % Clear 'word' variable
      word=[ ];

    else
      disp('wtf');
      reconheceCedula(nota, 5);
    end
    %*When the sentences finish, breaks the loop
    if isempty(re)  %See variable 're' in Fcn 'lines'
        break
    end    
end
fclose(fid);
%Open 'text.txt' file
%winopen('text.txt')
%fprintf('For more information, visit: <a href= "http://www.matpic.com">www.matpic.com </a> \n')
endfunction

reconheceCedula(nota100, 17);