clear all, close all, clc;

nota2   = imread('2.PNG');
nota5   = imread('5.PNG');
nota10  = imread('10.PNG');
nota20  = imread('20.PNG');
nota50  = imread('50.PNG');
nota100 = imread('100.jpg');

function reconheceCedula(nota)
  figure, imshow(nota);
  notaGray = imresize(rgb2gray(nota), [199 447]); 
  figure, imshow(notaGray);
  [lin col] = size(notaGray);

  x_ini = col - 100;

  teste = imcrop(notaGray, [x_ini, 1, 90, 70]);
  figure, imshow(teste);
  ocrResults = ocr(teste,'CharacterSet','.0123456789');
  recognizedText = ocrResults.Words;
endfunction

reconheceCedula(nota100);