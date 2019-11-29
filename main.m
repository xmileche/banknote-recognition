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
function reconheceCedula(nota, op)
  
  % Transformacao da imagem RGB em escala de cinza
  notaGray = imresize(rgb2gray(nota), [199 447]); 
  
  % Binariza a imagem e verifica sua respectiva area
  notaGraybw = im2bw(notaGray);
  area = bwarea(~notaGray);
  
  % Verifica se a imagem esta dentros dos padroes se sua area
  % Caso nao estiver, ela esta invertidade e a rotacao e necessaria
  if(area >= 8100 && area <= 8500 && op == 1) 
    notaGraybw = imrotate(notaGraybw,   180);
    
  elseif(area >= 5600 && area <= 5900 && op == 2) 
    notaGraybw = imrotate(notaGraybw, 180);

  elseif(area >= 8000 && area <= 8300 && op == 3) 
    notaGraybw = imrotate(notaGraybw, 180);

  elseif(area >= 2800 && area <= 2900 && op == 4)  
    notaGraybw = imrotate(notaGraybw, 180); 

  elseif(area >= 2200 && area <= 2300 && op == 5) 
    notaGraybw = imrotate(notaGraybw, 180);

  elseif(area >= 11000 && area <= 12000 && op == 6) 
    notaGraybw = imrotate(notaGraybw, 180);
  
  end
  
  % Visualizacao das notas depois do tratamento
  figure, imshow(nota);
  figure, imshow(notaGray);
  
  % Captura do tamanho da imagem e da indicacao da localizacao da mesma  
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

  % Caso a escolha seja a nota de 2 reais
  if(op == 1)
    nota2 = imread('2.PNG');
    reconheceCedula(nota2, op);
  endif

  % Caso a escolha seja a nota de 5 reais
  if(op == 2)
    nota5 = imread('5.PNG');
    reconheceCedula(nota5, op);
  endif

  % Caso a escolha seja a nota de 10 reais
  if(op == 3)
    nota10  = imread('10.PNG');
    reconheceCedula(nota10, op);
  endif

  % Caso a escolha seja a nota de 20 reais
  if(op == 4)
    nota20  = imread('20.PNG');
    reconheceCedula(nota20, op);
  endif

  % Caso a escolha seja a nota de 50 reais
  if(op == 5)
    nota50 = imread('50.PNG');
    reconheceCedula(nota50, op);
  endif

  % Caso a escolha seja a nota de 100 reais
  if(op == 6)
    nota100 = imread('100.jpg');
    reconheceCedula(nota100, op);
  endif

  % Caso o usuario deseja sair da execucao do programa
  if(op == 7)
    break;
  endif
  
endwhile