<!--
Computer Vision, Part 1: Introduction and Image Formation
Michael Sjöberg
July 13, 2022
May 29, 2023
-->

This is the first post in a series of lecture notes on computer vision, based on the postgraduate-level course with the same name at King's College London. These notes cover most of the topics, but not as deep and without assignments, and are primarily intended as a reference for myself.

### <a name="1" class="anchor"></a> [What is computer vision?](#1)

Computer vision is a subfield of artificial intelligence and used to describe methods for extracting information from images.

Related disciplines include:

- image processing, manipulation of an image
- computer graphics, digitally synthesizing images
- pattern recognition, recognizing and classifying stimuli in images and other datasets
- photogrammetry, obtaining measurements from images
- biological vision, understanding visual perception

Note that image processing is image-to-image and computer graphics is description-to-image, whereas computer vision is image-to-description. Computer vision is needed when machines interact with the physical world, such as in robotics, or use machines to extract useful information from images (and images are everywhere).

### <a name="1.2" class="anchor"></a> [1.2 Vision is an ill-posed problem](#1.2)

A transformation of an image into a description is not obvious, it is an ill-posed problem. One image can have many interpretations, one object can result in many images, so this problem is exponentially large:

- imaging: mapping from 3D to 2D is unique, problem is well-posed and forward
- vision: mapping from 2D to 3D is not unique, problem is ill-posed and inverse, many objects can generate similar image

Most vision systems use constraints and priors, as in prior knowledge, to make some interpretations more likely than others. Our brain produces one interpretation from many possible ones. In an image, an object can appear in any location, scale, orientation, and color, so the number of possible images of same object increases exponentially with the number of these parameters. Viewpoint, angle, illumination (light or dark), and deformations (smiling or tilting head), can affect appearance, and often results in images of same the object with almost no visual similarity. A within-category variation (e.g., a calculator looks more like modern phone than modern phone looks like an old phone) and other objects in the same image, such as background and clutter, can also result in images with no visual similarity.

#### <a name="1.2.1" class="anchor"></a> [Inference](#1.2.1)

Human perception use inference, which is prior information about the world, to constrain results and (sometimes) produce a more accurate interpretation:

- [checker board with added shadow](https://en.wikipedia.org/wiki/Checker_shadow_illusion) (illumination) can result in perceived intensity, not reflecting actual image intensity, making shadowed tiles look lighter than actual
- [Ames Room illusion](https://en.wikipedia.org/wiki/Ames_room) (perspective)
- knowing what an image look like makes it easier to see something that was harder to see before (prior knowledge)
- expecting an image to look a certain way makes it hard to spot variations (prior expectation), such as common brand with typo or different text
- exposure to an image makes it hard to spot changes to same image (prior exposure, [change blindness](https://en.wikipedia.org/wiki/Change_blindness)), such as removing an object from a scene in image
- knowing context makes it easier to complete otherwise incomplete images, such as letter missing in common word

Human perception is influenced by prior expectations, or simply priors, and the examples listed above are illusions, which is from assumptions that our vision system makes to solve an under-constrained problem:

- prior knowledge, or familiarity, such as previous experience with certain objects or knowledge about formation process in general
- prior exposure, motion, or priming, which is recent or preceding input
- current context, such as objects surrounding visual scene, and concurrent input

## <a name="2" class="anchor"></a> [2. Image formation](#2)

### <a name="2.1" class="anchor"></a> [2.1 Physics](#2.1)

An image is formed when a sensor registers radiation that interacted with a physical object. An image that is formed is affected by two types of parameters (note that camera and computer vision systems can also work with non-human-visible wavelengths, such as infra-red and x-ray):

- radiometric, to determine intensity (color, earth surface intensity spectrum between 400-700 nm), illumination (type and location), surface reflectance properties (material and orientation), and sensor properties (sensitivity)
- geometric, to determine where a scene point is in the image, camera position and orientation in space, camera optics (focal length), and projection geometry (mapping 3D to 2D)

#### <a name="2.1.1" class="anchor"></a> [Colors](#2.1.1)

Colors are created from mixing light, or additive, adds illumination to increase intensity, which results in a white color at extreme, or mixing pigments, or subtractive, reflects illumination to decrease intensity, which result in a black color at extreme. A color is determined by luminance, which is amount of light striking sensor, illuminance, which amount of light striking surface, and reflectance, which is light absorbed (depends on surface material). So, luminance at a location, $(x, y)$, and wavelength, $w$, is a function of illuminance and reflectance at same location and wavelength:

- if illuminance of light changes, intensity of light also changes (luminance changes with illuminance)
- if reflectance of light changes, intensity of light also changes (luminance changes with reflectance)

The human eye seems to recover surface color, illuminance, since perceived colors remain unchanged with changes to illumination, such as looking at color of fruits in different lightning.

### <a name="2.2" class="anchor"></a>  [2.2 Geometry](#2.2)

Light spreads out from a point, where focus is light converging (restricting flow of light) into a single image point and exposure is time needed to allow light through to form an image. The [pinhole camera model](https://en.wikipedia.org/wiki/Pinhole_camera_model) describes that a small pinhole gives sharp focus and dim image (long exposure) and large pinhole gives bright but blurred image (short exposure). 

#### <a name="2.2.1" class="anchor"></a> [Lenses](#2.2.1)

A lens can be used with large pinhole to produce a bright and sharp image, the lens keeps light from spreading out (light is refracted):

- a lens is positioned between object and image
	- light passing through optical center is not refracted
	- light passing in parallel to optical axis is refracted to pass through the image-side focal point
	- light passing through object-side focal point it refracted to pass in parallel to optical axis

- the thin lens equation is $\frac{1}{f} = \frac{1}{\|z\|} + \frac{1}{\|z'\|}$ where $f$ is focal length	
	- distance between image-side focal point and object-side focal point, $z$ is object distance from lens, and $z'$ is image distance from lens

A lens follows the pinhole model (also called perspective camera model) for objects that are in focus:

- $P$ is a point with coordinates $(x, y, z)$, $P'$ is its image with coordinates $(x', y', z')$, and $O$ is the origin (or pinhole, center of lens)
- image plane is located at distance $f'$ from pinhole, optical axis is line perpendicular to image plane and passing through $O$, and $C'$ is image center (intersection of optical axis and image plane)
	- the equation of projection in 2D is $\frac{x'}{x} = \frac{f'}{z} \Rightarrow x' = \frac{f'}{z}x$
	- the equation of projection in 3D is $x' = \frac{f'}{z}x, y' = \frac{f'}{z}y, z' = f'$

#### <a name="2.2.2" class="anchor"></a> [External reference frame](#2.2.2)

An external reference frame is used when camera is moving or with more than one camera (stereo vision):

- $O_{XYZ}$ is world reference frame and $O_{xyz}$ is camera reference frame
- $P$ is coordinates of point in frame $O_{XYZ}$ and $t$ is coordinates of origin of frame $O_{xyz}$ in frame $O_{XYZ}$ (translation vector)
- $R$ is rotation matrix describing orientation of frame $O_{xyz}$ with respect of $O_{XYZ}$
- $p$ is coordinates of point in frame $O_{xyz}$

In Euclidean geometry, objects are described as they are, transformations within a 3D world, translations and rotations, and same shape. In projective geometry, objects are described as they appear, transformations from a 3D world to a 2D image, scaling and shear in addition to translation and rotation. A vanishing point is a projection of a point at infinity, such as looking at train tracks in the distance.

### <a name="2.3" class="anchor"></a> [2.3 Digital images](#2.3)

A digital image is represented as a 2D array with numbers and is sampled at discrete points (pixels), value at each pixel is light intensity at that point (0 is black and 255 is white, sometimes 1 is white). An image is usually denoted as $I$, origin is in top-left corner, where a point on the image is denoted as $p$, such as $p = (x, y)^{T}$, where $p$ is a transposed vector, and pixel value is denoted as $I(p)$, or $I(x, y)$. An intensity value is averaged at sampling point, also called pixelization, and represented using finite discrete values (quantization):

- 1 bit per pixel gives 2 gray levels (binary)
- 2 bit per pixel gives 4 gray levels
- 8 bit per pixel gives 256 gray levels
- 8 bit per pixel and 3 real values (RGB) gives 24 bits (true color)

#### <a name="2.3.1" class="anchor"></a> [Charge-coupled devices](#2.3.1)

A charge-coupled device (CCD) is a semiconductor with a two-dimensional matrix of photo-sensors (photodiodes) where each sensor is small and isolated capacitive region, which can accumulate charge. The photoelectric effect converts photons on sensors into electrons, the accumulated charge is proportional to light intensity and exposure time. CCDs can be used with colored filters to make different pixels selective to different colors, such as [Bayer filter](https://en.wikipedia.org/wiki/Bayer_filter). 

#### <a name="2.3.2" class="anchor"></a> [Bayer filter](#2.3.2)

A Bayer filter, or mask, has twice as many green filters as red and blue, samples colors at specific locations, and use [demosaicing](https://en.wikipedia.org/wiki/Demosaicing), which is an algorithm used to compute color at pixel (based on local red, green, blue values in subsampled images) to fill in missing values:

- nearest neighbor interpolation copies adjacent pixel value in same color channel and is fast but inaccurate
- bilinear interpolation takes average of nearest two-to-four-pixel value in same color channel is fast and accurate in smooth regions, but inaccurate at edges
- smooth hue transition interpolation (only red and blue, green is same as bilinear interpolation) takes ratio of bilinear interpolation between red/ blue and green
- edge-directed interpolation performed on axis where change in value is lowest

### <a name="2.4" class="anchor"></a> [2.4 The human eye](#2.4)

The human eye has several parts (listing relevant only):

- cornea, perform initial refraction at fixed focus
- lens, perform further refraction and can be stretched to change focal length
- iris, allow regulation of exposure to light, both as protection and to improve focus
- optic nerve, transmit information to brain
- retina, contains light sensitive photoreceptors, where photoreceptors are farthest from light and transduce, or transform a form of energy to another, light to electric signals as voltage charges

#### <a name="2.4.1" class="anchor"></a> [Photoreceptors](#2.4.1)

A [photoreceptor](https://en.wikipedia.org/wiki/Photoreceptor_cell) is a rod, highly sensitive and can operate in low light levels, or a cone, low sensitivity but sensitive to different wavelengths. Blue has short-wavelength and peak sensitivity 440nm, green has medium-wavelength and peak sensitivity 545nm, and red has long-wavelength and peak sensitivity 580nm. A blind spot has no photoreceptors (it is blind), the fovea has no rods but many cones, and periphery has many rods and few cones. The fovea is high resolution (high density of photoreceptors), color (cones), and low sensitivity (no rods), whereas the periphery is low resolution (low density of photoreceptors), monochrome (rods), and high sensitivity (rods).

#### <a name="2.4.2" class="anchor"></a> [Centre-surround RF function](#2.4.2)

A center-surround receptive field (RF) is an area of visual space from which neuron receive input:

- on-center/off-surround is active if stimulus is brighter than background
- off-center/on-surround is active if stimulus is darker than background

A center-surround RF measure change in intensity, or contrast, between adjacent locations. The relative contrast should be independent of lightning conditions, so illuminance should be irrelevant.