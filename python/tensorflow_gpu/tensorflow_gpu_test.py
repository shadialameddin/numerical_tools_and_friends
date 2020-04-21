# CUDA_VISIBLE_DEVICES=0,1 python use_gpu.py

## GPU activities [CUDA memcpy HtoD] [CUDA memcpy DtoH]
# nvprof python use_gpu.py

 # https://www.tensorflow.org/guide/gpu
# from __future__ import absolute_import, division, print_function, unicode_literals
import tensorflow as tf

print("Num GPUs Available: ", len(tf.config.experimental.list_physical_devices('GPU')))
import numpy as np

tf.debugging.set_log_device_placement(True)
gpus = tf.config.experimental.list_physical_devices('GPU')

if gpus:
    try:
        for gpu in gpus:
            # Memory growth has to be enabled in order to not block the whole GPU memory
            # Currently, memory growth needs to be the same across GPUs
            tf.config.experimental.set_memory_growth(gpu, True)

            # Restrict TensorFlow to only use the first GPU
            # tf.config.experimental.set_visible_devices(gpus[0], 'GPU')

            # Restrict TensorFlow to only allocate 1GB of memory on the first GPU
            # tf.config.experimental.set_virtual_device_configuration(gpus[0],[tf.config.experimental.VirtualDeviceConfiguration(memory_limit=1024)])

            # Create 2 virtual GPUs with 800MB memory each
            # tf.config.experimental.set_virtual_device_configuration(gpus[0],[tf.config.experimental.VirtualDeviceConfiguration(memory_limit=800),tf.config.experimental.VirtualDeviceConfiguration(memory_limit=800)])
            logical_gpus = tf.config.experimental.list_logical_devices('GPU')
            print(len(gpus), "Physical GPUs,", len(logical_gpus), "Logical GPU")

    except RuntimeError as e:
        # Visible devices must be set before GPUs have been initialized
        print(e)



for i in range(50000):
    # Create some tensors
    a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
    b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
    c = tf.matmul(a, b)
    d = np.array(c) # device to host
    # print(c)

    # Place tensors on the CPU
    with tf.device('/CPU:0'):
      a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
      b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
      c = tf.matmul(a, b)
    d = np.array(c)
    # print(c)


# Not tested, how to use multiple GPUs
# NUM_GPUS = 2
# strategy = tf.contrib.distribute.MirroredStrategy(num_gpus=NUM_GPUS)
# config = tf.estimator.RunConfig(train_distribute=strategy)
# estimator = tf.keras.estimator.model_to_estimator(model,config=config)


# tensorboard profiler??
