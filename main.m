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
%   chmod +x run_ocrad.sh                                                              %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Limpeza da area de trabalho e carregamento do pacote de imagem
clear all, close all, clc;
pkg load image;

% Criacao de variaveis globais para captura de quantidade
% de cada cedula de real
global contador2 = 0 e contador5 = 0 e contador10 = 0;
global contador20 = 0 e contador50 = 0 e contador100 = 0;

% Armazenamento de cada cedula de real
nota2    = imread('2.PNG');
nota5    = imread('5.PNG');
nota10   = imread('10.PNG');
nota20   = imread('20.PNG');
nota50   = imread('50.PNG');
nota100  = imread('100.jpg');

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
  op = menu("Escolha uma opção:", "[1] 2 reais ","[2] 5 reais",
            "[3] 10 reais", "[4] 20 reais", "[5] 50 reais", "[6] 100 reais", "[7] Sair");

  % Caso a escolha seja a nota de 2 reais
  if(op == 1)
    reconheceCedula(nota2, op);
    contador2 = contador2 + 1;
  endif

  % Caso a escolha seja a nota de 5 reais
  if(op == 2)
    reconheceCedula(nota5, op);
    contador5 = contador5 + 1;
  endif

  % Caso a escolha seja a nota de 10 reais
  if(op == 3)
    reconheceCedula(nota10, op);
    contador10 = contador10 + 1;
  endif

  % Caso a escolha seja a nota de 20 reais
  if(op == 4)
    reconheceCedula(nota20, op);
    contador20 = contador20 + 1;
  endif

  % Caso a escolha seja a nota de 50 reais
  if(op == 5)
    reconheceCedula(nota50, op);
    contador50 = contador50 + 1;
  endif

  % Caso a escolha seja a nota de 100 reais
  if(op == 6)
    reconheceCedula(nota100, op);
    contador100 = contador100 + 1;
  endif

  % Caso o usuario deseja sair da execucao do programa
  if(op == 7)
    break;
  endif
  
endwhile

% Represetação do resultado final
figure, subplot(2, 3, 1), imshow(nota2), title(['Cédula de 2 - Quantidade: ', num2str(contador2)]), grid off;
subplot(2, 3, 2), imshow(nota5), title(['Cédula de 5 - Quantidade: ', num2str(contador5)]), grid off;
subplot(2, 3, 3), imshow(nota10), title(['Cédula de 10 - Quantidade: ', num2str(contador10)]), grid on;
subplot(2, 3, 4), imshow(nota20), title(['Cédula de 20 - Quantidade: ', num2str(contador20)]);
subplot(2, 3, 5), imshow(nota50), title(['Cédula de 50 - Quantidade: ', num2str(contador50)]);
subplot(2, 3, 6), imshow(nota100), title(['Cédula de 100 - Quantidade: ', num2str(contador100)]);

