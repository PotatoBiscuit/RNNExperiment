%Create RNN (If you want to add more layers, add another number like this:
%[8 8 8...]
lrn_net = layrecnet(1,[8]);
%Set training method
lrn_net.trainFcn = 'trainbr';
%Not sure what this is
lrn_net.trainParam.show = 5;
%Number of training iterations
lrn_net.trainParam.epochs = 50;