%%% Test unknown sample image using ASL_recogntion
unknownSample = fullfile([pwd '\sample_v1'], 'y11.fig');
fprintf(1, '\nIdentifiying unknown sample %s\n', unknownSample);
imTemp1 = openfig(unknownSample,'invisible');
imTemp2 = findobj(imTemp1,'type','image');
inputImage = imTemp2.CData;
HandRightState = 1;
Alphabet = ASL_recognition(HandRightState, inputImage)