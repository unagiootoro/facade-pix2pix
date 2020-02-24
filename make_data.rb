# Load the saved DCGAN model and save the Generator weight.

require "dnn"
require_relative "dcgan"

# Epoch of the model to load.
epoch = 300

dcgan = DCGAN.load("trained/dcgan_model_epoch#{epoch}.marshal")
gen = dcgan.gen
gen.save_params("trained/trained_generator_params.marshal")
