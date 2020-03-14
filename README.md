# facade-pix2pix
Perform image conversion of facade dataset with Pix2pix and ruby-dnn.

![image](https://user-images.githubusercontent.com/5798442/75152329-1df5cb00-574c-11ea-8620-f823d6a32fb9.png)

# Try
### Preparing for required installation
* [ruby-dnn](https://github.com/unagiootoro/ruby-dnn)
* [numo-linalg](https://github.com/ruby-numo/numo-linalg)
* [rubyzip](https://github.com/rubyzip/rubyzip)

### Clone repository
```
$ git clone https://github.com/unagiootoro/facade-pix2pix
```

### Start image conversion
```
$ ruby imgen.rb
```

### When performing full training
```
$ ruby train.rb
$ ruby make_data.rb
$ ruby imgen.rb
```

# Pix2pix
Pix2pix is a deep learning model mainly used for image conversion.
The biggest feature of Pix2pix is that it can generate clear images.
In normal image conversion, the pixel value determines how close the generated image is to the real image,
but Pix2pix automatically learns the criteria for determining how close the generated image is to the real image.
So, pixel values differ less in blurry images than in sharp images.
Therefore, by performing learning that does not depend on pixel values, a clear image can be generated.
