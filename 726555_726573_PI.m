% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%   Universidade Federal de São Carlos - Campus Sorocaba          %
%   Disciplina: Processamento de Imagens e Visão Computacional    %
%                                                                 %
%   Tema: Identificação de Cédulas (Reais)                        %
%                                                                 %
%   Leandro Naidhig           726555                              %
%   Michele Argolo Carvalho   726573                              %
%                                                                 %
%   Referências:                                                  %
%   Adapatação do código: Optical Caracter Recognition (OCR)      %  
%   https://github.com/khitk9738/OCR-Matlab                       %
%                                                                 %
%   Amostra de Imagens:                                           %
%   https://www.bcb.gov.br/cedulasemoedas/cedulasemitidas         %
%                                                                 %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Limpeza da area de trabalho e carregamento do pacote de imagem
clear all, close all, clc;
pkg load image; 

%===================================%
%         VARIAVEIS GLOBAIS         %
%===================================%
% Valor da cedula
global result;
global numbers = { };
global banknote2;
% Captura de quantidade de cada cedula de real
global contador2 = 0 e contador5 = 0 e contador10 = 0;
global contador20 = 0 e contador50 = 0 e contador100 = 0;

%===================================%
% Carrega todas as cedulas "Segunda Familia do Real"
nota2   = imread('2.PNG');
nota5   = imread('5.PNG');
nota10  = imread('10.PNG');
nota20  = imread('20.PNG');
nota50  = imread('50.PNG');
nota100 = imread('100.PNG');

%===================================%
%      TEMPLATE DOS NUMEROS         %
%===================================%
one     = imread('letters_numbers/1.bmp');  
two     = imread('letters_numbers/2.bmp');
three   = imread('letters_numbers/3.bmp');
four    = imread('letters_numbers/4.bmp');
five    = imread('letters_numbers/5.bmp'); 
six     = imread('letters_numbers/6.bmp');
seven   = imread('letters_numbers/7.bmp');
eight   = imread('letters_numbers/8.bmp');
nine    = imread('letters_numbers/9.bmp'); 
zero    = imread('letters_numbers/0.bmp');

% Insere os modelos de imagens para números na base de conhecimento
number    = [one two three four five six seven eight nine zero];
character = [number];

% Cada imagem possui dimensao 42 x 24
% Templates tem uma cédula de arrays 42 x 24
global templates = mat2cell(character, 42, [24 24 24 24 24 24 24 24 24 24]);

%===================================%
%            FUNCOES                %
%===================================%
% Retorna a imagem mais próxima dos valores brancos 
function [imgOut] = lines(imgIn)
  % Retorna imagem com valor branco
  [l c] = find(imgIn);   
  imgOut = imgIn(min(l):max(l), min(c):max(c)); 
endfunction


% Reconhece o numero de acordo com a imagem no parametro
function number = read_number(img)
  vector = [ ];
  global templates;
  
  % Percorre todos os numeros e calcula probabilidade dos coeficientes do template com a imagem
  for n = 1:10
    vector = [vector corr2(templates{1,n}, img)];
  end

  % Retorna o elemento no vetor com maior coeficiente
  result = find(vector == max(vector));

  switch (result)
  case 1
    number = '1';
  case 2
    number = '2';
  case 3
    number = '3';
  case 4
    number = '4';
  case 5
    number = '5';
  case 6
    number = '6';
  case 7
    number = '7';
  case 8
    number = '8';
  case 9
    number = '9';
  case 10
    number = '0';
  endswitch
endfunction

% Funcao principal para reconhecimento das cedulas
function recognizeBanknote(banknote, initialX)
  global result;
  global contador2 e contador5 e contador10 e contador20 e contador50 e contador100;
  global templates;
  numbers = { };
  recognize = 1;
  
  % Redimensiona a imagem para o maior valor possivel (100)
  banknoteGray = imresize(rgb2gray(banknote), [199 447]); 
  [lin col] = size(banknoteGray);
  global banknote2 = banknoteGray; 
  
  % Realiza o crop no canto superior direito da nota
  x_ini = col - 100;
  cropNumber = imcrop(banknoteGray, [x_ini, 1, 90, 70]);  
  cropNumber = imcrop(cropNumber, [initialX, 13, 70, 48]);  
  
  % Binarizacao da imagem com limiar perfeito
  img = ~im2bw(cropNumber, graythresh(cropNumber));
  
  % Remove imperfeicoes indesejadas (todos objetos com menos de 30 pixels)
  img = bwareaopen(img, 30);
  
  % Para armazenamento do reconhecimento dos numeros
  recognizeNumber = [ ];

  % Conta as componentes conectadas
  imgOut = lines(img);
  [labels num] = bwlabel(imgOut); 
  
  % Percorre todas as labels encontradas
  for n=1:num
    % Retorna a imagem mais próxima dos valores brancos da label especifica com redimensionamento
    [line, col] = find(labels == n);
    numberExtracted = imresize(imgOut(min(line):max(line), min(col):max(col)), [42 24]) ;  

    a{n} = numberExtracted; 
    numbers = [numbers numberExtracted];
            %-------------------------------------------------------------------
    % Converte a imagem para numero
    digitizedNumber = read_number(numberExtracted);
    % Concatenação dos numeros
    recognizeNumber = [recognizeNumber digitizedNumber];
  end
  
  result = str2num(recognizeNumber); 
  
  % Compara o valor retornado pelo OCR para identificar a nota 
  if (result == 2)
    contador2 = contador2 + 1;
    
  elseif (result == 5)
    contador5 = contador5 + 1;
  
  elseif (result == 10)
    contador10 = contador10 + 1;
  
  elseif (result == 20)
    contador20 = contador20 + 1;

  elseif (result == 50)
    contador50 = contador50 + 1;
  
  elseif (result == 100)
    contador100 = contador100 + 1;
   
  % Se nao encontrou a nota, precisamos realizar o crop de forma diferente 
  else 
    recognizeBanknote(banknote, 5);
    recognize = 0;
  endif 
  
  if recognize == 1
    figure, subplot(2, 4, 1), imshow(banknote), title('Imagem Original'), grid off;
    subplot(2, 4, 2), imshow(banknoteGray), title('Imagem em Cinza'), grid off;
    subplot(2, 4, 3), imshow(cropNumber), title('Crop do Número'), grid off;
    subplot(2, 4, 4), imshow(img), title('Número Binarizado'), grid on; 
    for k = 1:max(size(numbers))
      c =  cell2mat (numbers(k));
      subplot(2, 4, 4+k), imshow(mat2gray(c)), title(['Número: ', num2str(recognizeNumber(k))]);
    end
  end
endfunction

% Executa o procedimento até o usuário sair do programa
while(1)
  op = menu("Escolha uma opção:", "[1] Reconhecer cédula ","[2] Sair");
  
  if(op == 1)
    % Usuario escolhe a nota para analise
    [file, path] = uigetfile('*.PNG', 'Selecione uma nota');
    
    % Le a imagem e chama o reconhecedor para a mesma
    nota = imread(file);
    recognizeBanknote(nota, 17);
    msgbox ("Cédula reconhecida com sucesso.", "Aviso");
  elseif(op == 2)
    break
  endif
endwhile

% Quando termina de reconhecer todas exibe valor da contagem e resultado final
valorTotal = contador2 * 2 + contador5 * 5 + contador10 * 10 +  contador20 * 20 + contador50 * 50 + contador100 * 100;

% Represetação do resultado final
figure('name',['Valor Total: ', num2str(valorTotal)]), subplot(2, 3, 1), imshow(nota2), title(['Cédula de 2 - Quantidade: ', num2str(contador2)]), grid off;
subplot(2, 3, 2), imshow(nota5), title(['Cédula de 5 - Quantidade: ', num2str(contador5)]), grid off;
subplot(2, 3, 3), imshow(nota10), title(['Cédula de 10 - Quantidade: ', num2str(contador10)]), grid on;
subplot(2, 3, 4), imshow(nota20), title(['Cédula de 20 - Quantidade: ', num2str(contador20)]);
subplot(2, 3, 5), imshow(nota50), title(['Cédula de 50 - Quantidade: ', num2str(contador50)]);
subplot(2, 3, 6), imshow(nota100), title(['Cédula de 100 - Quantidade: ', num2str(contador100)]);
