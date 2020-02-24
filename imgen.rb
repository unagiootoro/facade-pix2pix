require "dnn"
require "dnn/image"
require "dnn/datasets/cifar10"
require "numo/linalg/autoloader"
require_relative "dcgan"
require_relative "facade_dataset"

def load_dataset
  x, y = DNN::Facade.load_test
  x = Numo::SFloat.cast(x)
  y = Numo::SFloat.cast(y)
  x = (x / 127.5) - 1
  y = (y / 127.5) - 1
  [x, y]
end

x_in, x_out = load_dataset
batch_size = x_in.shape[0]

# Load the Generator model.
gen = Generator.new([64, 64, 3])
gen.predict1(Numo::SFloat.zeros(64, 64, 3))
gen.load_params("trained/trained_generator_params.marshal")

batch_size.times do |i|
  # Save the input image.
  input = x_in[i, false]
  img = Numo::UInt8.cast(((input + 1) * 127.5).round)
  DNN::Image.write("img/img_#{i}_input.jpg", img)

  # Save the output image.
  out = gen.predict1(x_in[i, false])
  img = Numo::UInt8.cast(((out + 1) * 127.5).round)
  DNN::Image.write("img/img_#{i}_output.jpg", img)

  # Save the real image.
  real = x_out[i, false]
  img = Numo::UInt8.cast(((real + 1) * 127.5).round)
  DNN::Image.write("img/img_#{i}_real.jpg", img)
end
