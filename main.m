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

% Funcao responsavel por reconhecer a cedula escolhida
function reconheceCedula(nota)
  
  figure, imshow(nota);
  notaGray = imresize(rgb2gray(nota), [199 447]); 
  figure, imshow(notaGray);
  [lin col] = size(notaGray);
  frame2 = notaGray;
  x_ini = col - 100;
  
  % Realiza o crop do local em que se encontra a imagem
  teste = imcrop(notaGray, [x_ini, 1, 90, 70]);
  
  figure, imshow(teste);
  frame = teste;
  
  % Transforma o frame do numero em uma imagem
  imwrite(frame, "frame.pnm", 'WriteMode','overwrite');

  % Realiza uma chamada na linha de comando para rodar o script
  % de execucao para receber a imagem alvo para a transformacao
  % em texto dos caracteres recuperados da imagem
  system("./run_ocrad.sh frame.pnm");
  close all;

endfunction



% Executa o procedimento até o usuário sair do programa
while(1)

  % Usuario escolhe a nota para analise
  op = menu("Escolha uma opção:", "1) 2 reais ","2) 5 reais",
            "3) 10 reais", "4) 20 reais", "5) 50 reais", "6) 100 reais", "7) Sair");

  if(op == 1)
    nota2 = imread('2.PNG');
    reconheceCedula(nota2);
  endif

  if(op == 2)
    nota5 = imread('5.PNG');
    reconheceCedula(nota5);
  endif

  if(op == 3)
    nota10  = imread('10.PNG');
    reconheceCedula(nota10);
  endif

  if(op == 4)
    nota20  = imread('20.PNG');
    reconheceCedula(nota20);
  endif

  if(op == 5)
    nota50 = imread('50.PNG');
    reconheceCedula(nota50);
  endif

  if(op == 6)
    nota100 = imread('100.jpg');
    reconheceCedula(nota100);
  endif

  if(op == 7)
    break;
  endif
  
endwhile