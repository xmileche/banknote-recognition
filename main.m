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
function reconheceCedula(nota)
  global contador2 e contador5 e contador10 e contador20 e contador50 e contador100;
  
  % Transformacao da imagem RGB em escala de cinza
  % Redimensiona as imagens para a maior dimensao das notas (100)
  notaGray = imresize(rgb2gray(nota), [199 447]); 
  
  % Binariza a imagem e verifica sua respectiva area
  notaGraybw = im2bw(notaGray);
  area = bwarea(~notaGray);
  
  % Visualizacao das notas depois do tratamento
  figure, imshow(nota);
  figure, imshow(notaGray);
  
  % Captura do tamanho da imagem   
  [lin col] = size(notaGray);
  frame2 = notaGray;
  x_ini = col - 100;
  
  % Realiza o crop no canto superior direito (onde localiza-se o numero da nota)
  notaValor = imcrop(notaGray, [x_ini, 1, 90, 70]);
  
  % Filtro da mediana para melhorar imagem recortada
  size_template = 3;
  [lin, col] = size(notaValor);
  for i = 2:(lin - fix(size_template/2))
    for j = 2:(col - fix(size_template/2))
      k = 1;
      for m = i-1:i+1
        for n = j-1:j+1
          vetor_elem_mediana(k) = notaValor(m, n);
          k = k+1;
        end
      end
      vetor_elem_mediana = sort(vetor_elem_mediana);
      notaValor(i,j) = vetor_elem_mediana(fix(length(vetor_elem_mediana)/2)+1);
    end
  end
  figure, imshow(notaValor), title('filtro mediana');

  % aumenta o brilho
  notaValor = notaValor + 100;
  
  figure, imshow(notaValor);
  frame = notaValor;
  
  % Transforma o frame do numero em uma imagem
  imwrite(frame, "frame.pnm", 'WriteMode','overwrite');

  % Realiza uma chamada na linha de comando para rodar o script
  % de execucao para receber a imagem alvo para a transformacao
  % em texto dos caracteres recuperados da imagem
  [status, output] = system("./run_ocrad.sh frame.pnm");
  global valor;
  output = str2num(output);
  valor = output;
  
  % Compara o valor retornado pelo OCR para identificar a nota 
  if (output == 2)
    contador2 = contador2 + 1;
    
  elseif (output == 5)
    contador5 = contador5 + 1;
  
  elseif (output == 10)
    contador10 = contador10 + 1;
  
  elseif (output == 20)
    contador20 = contador20 + 1;

  elseif (output == 50)
    contador50 = contador50 + 1;
  
  elseif (output == 100)
    contador100 = contador100 + 1;
  endif 
    
  % Se não reconhece a imagem, então a cédula tem tom rosa (caso 5 e 10)
  % Neste caso, aumentamos o brilho (fonte: https://publish.illinois.edu/commonsknowledge/2017/07/19/what-to-do-when-ocr-software-doesnt-seem-to-be-working/)
  
  disp(valor);


endfunction

% Executa o procedimento até o usuário sair do programa
while(1)
  global valor;
  op = menu("Escolha uma opção:", "[1] Reconhecer cédula ","[2] Sair");
  
  if(op == 1)
    % Usuario escolhe a nota para analise
    [file, path] = uigetfile('*.PNG', 'Selecione uma nota');
    
    nota = imread(file);
    reconheceCedula(nota);
  
  elseif(op == 2)
    break
  endif
  
endwhile

valorTotal = contador2 * 2 + contador5 * 5 + contador10 * 10 +  contador20 * 20 + contador50 * 50 + contador100 * 100;

% Represetação do resultado final
figure('name',['Valor Total: ', num2str(valorTotal)]), subplot(2, 3, 1), imshow(nota2), title(['Cédula de 2 - Quantidade: ', num2str(contador2)]), grid off;
subplot(2, 3, 2), imshow(nota5), title(['Cédula de 5 - Quantidade: ', num2str(contador5)]), grid off;
subplot(2, 3, 3), imshow(nota10), title(['Cédula de 10 - Quantidade: ', num2str(contador10)]), grid on;
subplot(2, 3, 4), imshow(nota20), title(['Cédula de 20 - Quantidade: ', num2str(contador20)]);
subplot(2, 3, 5), imshow(nota50), title(['Cédula de 50 - Quantidade: ', num2str(contador50)]);
subplot(2, 3, 6), imshow(nota100), title(['Cédula de 100 - Quantidade: ', num2str(contador100)]);

