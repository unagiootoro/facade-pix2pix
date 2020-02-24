require "dnn"
require "dnn/datasets/cifar10"
require "numo/linalg/autoloader"
require_relative "dcgan"
require_relative "facade_dataset"

include DNN::Optimizers
include DNN::Losses

def load_dataset
  x, y = DNN::Facade.load_train
  x = Numo::SFloat.cast(x)
  y = Numo::SFloat.cast(y)
  x = (x / 127.5) - 1
  y = (y / 127.5) - 1
  [x, y]
end

initial_epoch = 301

epochs = 400
batch_size = 64

if initial_epoch == 1
  gen = Generator.new([64, 64, 3])
  dis = Discriminator.new([64, 64, 3], [64, 64, 3])
  dcgan = DCGAN.new(gen, dis)
  dis.setup(Adam.new(alpha: 0.00001, beta1: 0.1), SigmoidCrossEntropy.new)
  dcgan.setup(Adam.new(alpha: 0.0002, beta1: 0.5),
              [MeanAbsoluteError.new, SigmoidCrossEntropy.new], loss_weights: [10, 1])
else
  dcgan = DCGAN.load("trained/dcgan_model_epoch#{initial_epoch - 1}.marshal")
  gen = dcgan.gen
  dis = dcgan.dis
end

x_in, x_out = load_dataset

iter1 = DNN::Iterator.new(x_in, x_out)
iter2 = DNN::Iterator.new(x_in, x_out)
num_batchs = x_in.shape[0] / batch_size
(initial_epoch..epochs).each do |epoch|
  num_batchs.times do |index|
    x_in, x_out = iter1.next_batch(batch_size)

    images = gen.predict(x_in)
    y_real = Numo::SFloat.ones(batch_size, 1)
    y_fake = Numo::SFloat.zeros(batch_size, 1)
    dis.enable_training
    dis_loss = dis.train_on_batch([x_in, x_out], y_real)
    dis_loss += dis.train_on_batch([x_in, images], y_fake)

    x_in, x_out = iter2.next_batch(batch_size)
    dcgan_loss = dcgan.train_on_batch(x_in, [x_out, y_real])

    puts "epoch: #{epoch}, index: #{index}, dis_loss: #{dis_loss}, dcgan_loss: #{dcgan_loss}"
  end
  iter1.reset
  iter2.reset
  dcgan.save("trained/dcgan_model_epoch#{epoch}.marshal") if epoch % 50 == 0
end
