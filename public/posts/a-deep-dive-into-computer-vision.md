<!--
    A Deep Dive into Computer Vision
    Michael Sjöberg
    July 13, 2022
-->

## <a name="1" class="anchor"></a> [1. Introduction](#1)

*Keywords: image processing, ill-posed problems, inference, illusions*

### <a name="1.1" class="anchor"></a> [1.1 What is computer vision?](#1.1)

Computer vision is a field of artificial intelligence and generally used to describe methods for extracting information from images. Related disciplines include (note that image processing is image to image and computer graphics is description to image, whereas computer vision is image to description):

- image processing, manipulation of an image
- computer graphics, digitally synthesizing images
- pattern recognition, recognising and classifying stimuli in images and other datasets
- photogrammetry, obtaining measurements from images
- biological vision, understanding visual perception

Computer vision is needed when machines interact with the physical world, such as in robotics, or use machines to extract useful information from images (and images are everywhere). A few example applications:

- industrial inspection, QA
- robot navigation, mars rover use panorama stiching, 3D terrain modeling, obstacle detection, and position tracking
- autonomous vehicles, driver assistance, such as lane assist, pedestrian detection, and automatic breaking
- guiding tools and support for visually impaired
- surveillance and security, such as face detection and recognition at airports, people tracking for crime detection
- object recognition, text to speech, such as optical character recognition to convert scanned documents to text, automatic numberplate recognition, face detection in images, track objects in real-time
- medical image analysis, such as MRI, CT, and ultrasound scanners
- digital libraries and video search, such as content-based image retrieval (query by image)

### <a name="1.2" class="anchor"></a> [1.2 Vision is an ill-posed problem](#1.2)

A transformation of an image into a description is not obvious, it is an ill-posed problem. One image can have many interpretations, one object can result in many images, and this problem is exponentially large:

- mapping from 3D to 2D is unique, problem is well-posed and forward (imaging)
- mapping from 2D to 3D is not unique, problem is ill-posed and inverse (vision), many objects can generate similar image

Computer vision systems use constraints and priors, as in prior knowledge, to make some interpretations more likely than others. Our brain produce one interpretation from many possible ones. In an image, an object can appear in any location, scale, orientation, and color, so the number of possible images of same object increases exponentially with the number of parameters. Parameters such as viewpoint, angle, illumination, such as light or dark, and deformations, such as smiling or tilting head, can affect appearance, which often results in images of same object with almost no visual similarity. A within-category variation (a calculator is more similar to modern phone than a modern phone is to an old phone) and other objects in the same image, such as background and clutter, can also result in images with no visual similarity.

#### <a name="1.2.1" class="anchor"></a> [Inference](#1.2.1)

Human perception use inference, or prior information about the world, to constrain results and (sometimes) produce a more accurate interpretation:

- [checker board with added shadow](https://en.wikipedia.org/wiki/Checker_shadow_illusion) (illumination) can result in perceived intensity, not reflecting actual image intensity, making shadowed tiles look lighter than actual
- [Ames Room illusion](https://en.wikipedia.org/wiki/Ames_room) (perspective)
- knowing what an image look like makes it easier to see something that was harder to see before (prior knowledge)
- expecting an image to look a certain way makes it hard to spot variations (prior expectation), such as common brand with typo or different text
- exposure to an image makes it hard to spot changes to same image (prior exposure, [change blindness](https://en.wikipedia.org/wiki/Change_blindness)), such as removing an object from a scene in image
- knowing context makes it easier to complete otherwise incomplete images, such as letter missing in common word

The examples listed above are often referred to as illusions, which is from assumptions that our vision system makes to solve an under-constrained problem. Human perception is influenced by prior expectations, or priors:

- prior knowledge, or familiarity, such as previous experience with certain objects or knowledge about formation process in general
- prior exposure, motion, or priming, which is recent or preceding input
- current context, such as objects surrounding visual scene, and concurrent input

## <a name="2" class="anchor"></a> [2. Image formation](#2)

*Keywords: colors, light, external reference frame, CCD, human eye, receptive fields*

### <a name="2.1" class="anchor"></a> [2.1 Physics](#2.1)

An image is formed when a sensor registers radiation that interacted with a physical object. An image that is formed is affected by two types of parameters (note that camera and computer vision systems can also work with non-human-visible wavelengths, such as infra-red and x-ray):

- radiometric, to determine intensity (color, earth surface intensity spectrum between 400-700 nm), illumination (type and location), surface reflectance properties (material and orientation), and sensor properties (sensitivity)
- geometric, to determine where a scene point is in the image, camera position and orientation in space, camera optics (focal length), and projection geometry (mapping 3D to 2D)

#### <a name="2.1.1" class="anchor"></a> [Colors](#2.1.1)

Colors are created from mixing light, or additive, adds illumination to increase intensity, which results in a white color at extreme, or mixing pigments, or subtractive, reflects illumination to decrease intensity, which result in a black color at extreme. A color is determined by luminance, which is amount of light striking sensor, illuminance, which amount of light striking surface, and reflectance, which is light absorbed (depends on surface material). So, luminance at a location, $(x, y)$, and wavelength, $w$, is a function of illuminance and reflectance at same location and wavelength:

- if illuminance of light changes, intensity of light also changes (luminance changes with illuminance)
- if reflectance of light changes, intensity of light also changes (luminance changes with reflectance)

The human eye seem to recover surface color, illuminance, since percieved colors remain unchanged with changes to illumination, such as looking at color of fruits in different lightning.

### <a name="2.2" class="anchor"></a>  [2.2 Geometry](#2.2)

Light spreads out from a point, where focus is light converging (restricting flow of light) into a single image point and exposure is time needed to allow light through to form an image. The [pinhole camera model](https://en.wikipedia.org/wiki/Pinhole_camera_model) describes that a small pinhole gives sharp focus and dim image (long exposure) and large pinhole gives bright but blurred image (short exposure). 

#### <a name="2.2.1" class="anchor"></a> [Lens](#2.2.1)

A lens can be used with large pinhole to produce a bright and sharp image, the lens keeps light from spreading out (light is refracted):

- a lens is positioned between object and image
	- light passing through optical centre is not refracted
	- light passing in parallell to optical axis is refracted to pass through the image-side focal point
	- light passing through object-side focal point it refracted to pass in parallel to optical axis
- the thin lens equation is $$\frac{1}{f} = \frac{1}{\|z\|} + \frac{1}{\|z'\|}$$ where $f$ is focal length
	- distance between image-side focal point and object-side focal point, $z$ is object distance from lens, and $z'$ is image distance from lens

A lens follow the pinhole model (also called perspective camera model) for objects that are in focus:

- $P$ is a point with coordinates $(x, y, z)$, $P'$ is its image with coordinates $(x', y', z')$, and $O$ is the origin (or pinhole, center of lens)
- image plane is located at distance $f'$ from pinhole, optical axis is line perpendicular to image plane and passing through $O$, and $C'$ is image centre (intersection of optical axis and image plane)
	- the equation of projection in 2D is $$\frac{x'}{x} = \frac{f'}{z} \Rightarrow x' = \frac{f'}{z}x$$
	- the equation of projection in 3D is $$x' = \frac{f'}{z}x, y' = \frac{f'}{z}y, z' = f'$$

#### <a name="2.2.2" class="anchor"></a> [External reference frame](#2.2.2)

An external reference frame is useful when camera is moving or when using more than one camera (stereo vision):

- $O_{XYZ}$ is world reference frame and $O_{xyz}$ is camera reference frame
- $P$ is coordinates of point in frame $O_{XYZ}$ and $t$ is coordinates of origin of frame $O_{xyz}$ in frame $O_{XYZ}$ (translation vector)
- $R$ is rotation matrix describing orientation of frame $O_{xyz}$ with respect of $O_{XYZ}$
- $p$ is coordinates of point in frame $O_{xyz}$

In euclidean geometry, objects are described as they are, transformations within a 3D world, translations and rotations, and same shape. In projective geometry, objects are described as they appear, transformations from a 3D world to a 2D image, scaling and shear in addition to translation and rotation. A vanishing point is a projection of a point at infinity, such as looking at train tracks in the distance.

### <a name="2.3" class="anchor"></a> [2.3 Digital images](#2.3)

A digital image is represented as a 2D array with numbers and is sampled at discrete points (pixels), value at each pixel is light intensity at that point (0 is black and 255 is white, sometimes 1 is white). An image is usually denoted as $I$, origin is in top-left corner, where a point on the image is denoted as $p$, such as $p = (x, y)^{T}$, where $p$ is a transposed vector, and pixel value is denoted as $I(p)$, or $I(x, y)$. An intensity value is averaged at sampling point, also called pixelisation, and represented using finite discrete values (quantization):

- 1 bit per pixel gives 2 gray levels (binary)
- 2 bit per pixel gives 4 gray levels
- 8 bit per pixel gives 256 gray levels
- 8 bit per pixel and 3 real values (RGB) gives 24 bit (true color)

#### <a name="2.3.1" class="anchor"></a> [CCD](#2.3.1)

A charge-coupled device (CCD) is a semiconductor with a two-dimensional matrix of photo-sensors (photo-diodes) where each sensor is small and isolated capacitive region, which can accumulate charge. The photoelectric effect converts photons on sensors into electrons, the accumulated charge is proportional to light intensity and exposure time. CCDs can be used with colored filters to make different pixels selective to different colors, such as [Bayer filter](https://en.wikipedia.org/wiki/Bayer_filter). 

#### <a name="2.3.2" class="anchor"></a> [Bayer filter](#2.3.2)

A Bayer filter, or mask, has twice as many green filters as red and blue, samples colors at specific locations, and use [demosaicing](https://en.wikipedia.org/wiki/Demosaicing), which is an algorithm used to compute color at pixel (based on local red, green, blue values in subsampled images) to fill in missing values:

- nearest neighbour interpolation copies adjacent pixel value in same color channel and is fast but inaccurate
- bilinear interpolation takes average of nearest two to four pixel value in same color channel is fast and accurate in smooth regions, but inaccurate at edges
- smooth hue transition interpolation (only red and blue, green is same as bilinear interpolation) takes ratio of bilinear interpolation between red/ blue and green
- edge-directed interpolation performed on axis where change in value is lowest

### <a name="2.4" class="anchor"></a> [2.4 The human eye](#2.4)

The human eye has several parts (listing relevant only):

- cornea, perform inital refraction at fixed focus
- lens, perform further refraction and can be stretched to change focal length
- iris, allow regulation of exposure to light, both as protection and to improve focus
- optic nerve, transmit information to brain
- retina, contains light sensitive photoreceptors, where photoreceptors are farthest from light and transduce, or transform a form of energy to another, light to electric signals as voltage charges

#### <a name="2.4.1" class="anchor"></a> [Photoreceptor](#2.4.1)

A [photoreceptor](https://en.wikipedia.org/wiki/Photoreceptor_cell) is a rod, highly sensitive and can operate in low light levels, or a cone, low sensitivity but sensitive to different wavelengths. The color blue has short-wavelength and peak sensitivity 440nm, green has medium-wavelength and peak sensitivity 545nm, and red has long-wavelength and peak sensitivity 580nm. 

A blind spot has no photoreceptors (it is blind), the fovea has no rods but many cones, and periphery has many rods and few cones. The fovea is high resolution (high density of photoreceptors), color (cones), and low sensitivity (no rods), whereas the periphery is low resolution (low density of photoreceptors), monochrome (rods), and high sensitivity (rods).

#### <a name="2.4.2" class="anchor"></a> [Centre-surround RF function](#2.4.2)

A centre-surround receptive field (RF) is an area of visual space from which neuron recieve input:

- on-centre/off-surround is active if stimulus is brighter than background
- off-centre/on-surround is active if stimulus is darker than background

A centre-surround RF measure change in intensity, or contrast, between adjacent locations. The relative contrast should be independent of lightning conditions, so illuminance should be irrelevant.

## <a name="3" class="anchor"></a> [3. Low-level artificial vision](#3)

*Keywords: filters, Gaussian mask, image features*

### <a name="3.1" class="anchor"></a> [3.1 Convolution](#3.1)

The process of applying a filter, or mask, to an image is called convolution, where each location in an image $(i, j)$ is the weighted sum of pixel values in adjacent locations (range is defined by $k$ and $l$), so

$$I'(i, j) = IH = \sum I(i - k, j - l) H(k, l)$$

Convolution is commutative, $IH = HI$, and associative, $(IH)G = IHG$, so for each pixel (note that a 2D convolution is separable if $H$ is a convolution of two vectors, which is much more efficient, so $H = h_{1}h_{2}$):

- centre a rotated mask on pixel and multiply each mask element by corresponding image value (assume image values outside boundary is zero)
- sum products to get new pixel value

For more convolution examples, see: [Example of 2D Convolution](http://www.songho.ca/dsp/convolution/convolution2d_example.html).

### <a name="3.2" class="anchor"></a> [3.2 Filtering](#3.2)

A filter, or mask, is a point-spread function, image with isolated white dots on black bakground would superimpose mask at each pixel. A mask is a template and convolution output is maximum when large image values are multiplied with large mask values (respond most strongly at features similar to rotated mask), where rotated mask can be used as template to find image features:

-  each pixel replaced by itself

	|   |   |   |
	| - | - | - |
	| 0 | 0 | 0 |
	| 0 | 1 | 0 |
	| 0 | 0 | 0 |

- each pixel replaced by the one to the left (rotated)

	|   |   |   |
	| - | - | - |
	| 0 | 0 | 0 |
	| 0 | 0 | 1 |
	| 0 | 0 | 0 |

- each pixel replaced by average of itself and its eight neighbors, also called smoothing, mean filter, or box mask (weights add up to one to preserve average grey levels)

	|     |     |     |
	| --- | --- | --- |
	| 1/9 | 1/9 | 1/9 |
	| 1/9 | 1/9 | 1/9 |
	| 1/9 | 1/9 | 1/9 |

#### <a name="3.2.1" class="anchor"></a> [Gaussian mask](#3.2.1)

A [Gaussian mask](https://en.wikipedia.org/wiki/Gaussian_blur) gives more weight to nearby pixels to reduce hard edges (it is separable):

- $G(x, y) = \frac{1}{2 \pi \sigma^{2}} \exp \left(-\frac{x^{2} + y^{2}}{2 \sigma^{2}} \right)$
- $\sigma$, or scale, is the standard deviation, a higher scale gives more blurred images (more pixels are involved)

#### <a name="3.2.2" class="anchor"></a> [Difference mask](#3.2.2)

A difference mask is used to calculate differences instead of averages. The difference between pixel values gives gradient of intensity values (smoothing approximate mathematical integration, difference approximate differentiation) and highlight locations with intensity changes:

- weights add up to zero to generate zero response to constant image regions

	|    |    |    |
	| -- | -- | -- |
	| -1 | -1 | -1 |
	| -1 | 8  | -1 |
	| -1 | -1 | -1 |

Note that a [Laplacian mask](https://en.wikipedia.org/wiki/Discrete_Laplace_operator#Image_processing) is a combination of difference masks in each direction and detects intensity discontinuities at all orientations (sensitive to noise).

### <a name="3.3" class="anchor"></a> [3.3 Edge and feature detection](#3.3)

An edge, or discontinuity, is often where the intensity changes in an image. Edges can usually be found with difference masks and often correspond to physical characteristics, or features:

- depth discontinuity is due to surface at different levels
- orientation discontinuity is due to changes in orientation of surface
- reflectance discontinuity is due to changes in surface material properties
- illuminance discontinuity is due to changes in light (shadow not helpful to recognize object)

Edges are most efficiently detected using both differencing mask and smoothing mask, where one approach is Gaussian smoothing combined with Laplacian, also called Laplacian of Gaussian (LoG):

- an example Laplacian of Gaussian mask

	|     |     |     |
	| --- | --- | --- |
	| 1/8 | 1/8 | 1/8 |
	| 1/8 | 1   | 1/8 |
	| 1/8 | 1/8 | 1/8 |

Other methods to find edges include:

- Difference of Gaussian (DoG), difference operator combined with Gaussian smoothing (approximation to LoG)
- [Canny edge detector](https://en.wikipedia.org/wiki/Canny_edge_detector), convolution with derivatives of Gaussian masks to calculate magnitude and direction, non-maximum supression, and thresholding using both low and high threshold

#### <a name="3.3.1" class="anchor"></a> [Image feature](#3.3.1)

An image feature can be found at different scales by applying filters of different sizes, or applying filters at fixed size to an image of different sizes (most common). A down-sampling algorithm is often used to scale an image by taking every $n$-pixel and can be used recursively to create images in various sizes. However, results can be both good or bad (aliased, or not representative of image), where smoothing can be used to fix bad sampling:

- Gaussian pyramid, Gaussian smoothing applied recursively to a scaled image, which can be used to create scaled images that are representative to the original image
- Laplacian pyramid, Laplacian mask applied recursively to a scaled image, which can be used to detect intensity discontinuities in scaled images.

## <a name="4" class="anchor"></a> [4. Low and mid-level biological vision](#4)

*Keywords: visual cortex, 2D Gabor function, image components, object grouping*

### <a name="4.1" class="anchor"></a> [4.1 Biological visual system](#4.1)

In our brain, the cortex is responsible for all higher cognitive functions, such as perception, learning, language, memory, and reasoning, and the pathway from our retina to the cortex is not straightforward:

- the right visual field (RVF) projects to left side on each retina
- ganglion cells on left side in left eye projects to left lateral geniculate nucleus (LGN), where LGN cells have centre-surround RFs (similar to retinal ganglion cells)
- ganglion cells on left side in right eye cross over at optic chiasm to left LGN, so RVF projects to left LGN
- the left LGN projects to left primary visual cortex (V1), striate cortex, which performs initial low-level processing
- V1 to parietal cortex for spatial and motion information
- V1 to inferotemporal cortex for identity and categorical information

#### <a name="4.1.1" class="anchor"></a> [V1](#4.1.1)

The V1 have receptive fields (some similar to retinal ganglion cells) for color, orientation (stronger response at a specific angle, simple cells act as edge and bar detectors, complex cells act as edge and bar detectors with tolerance to location, hyper-complex cells are selective to length and optimal when matching width of RF), direction, spatial frequency, eye of origin (monocular cells are input from one eye only, binocular cells are optimal with same input from both eyes), binocular disparity (difference in location in each eye, depth of stimulus), and position.

The V1 have centre-surround RFs, which is similar to LGN and retina, double-opponent (DO) cells to detect location where color changes, and a hypercolumn, which is a collection of all neurons with RFs in same location on retina (each hypercolumn can process every image attribute).

### <a name="4.2" class="anchor"></a> [4.2 Gabor functions](#4.2)

A [2D Gabor function](https://en.wikipedia.org/wiki/Gabor_filter) is a Gaussian multiplied with a sinusoid:

- a cosine function with gaussian, where gaussian function goes towards zero on the edges
- simulate simple cells in one orientation, convolve image with gabor as mask
- simulate complex cells in one orientation, sum output from convolving image with gabor mask at different phases (multiple simple cells)
- simulate complex cells in multiple orientations (detect edges), sum output from convolving image with gabor mask at different phases and orientations

#### <a name="4.2.1" class="anchor"></a> [Image component](#4.2.1)

An image component is a small part of different images that are selected (as a mask) and summed to produce an image, such as set of hand written parts to generate a number as if written by different people:

- [Principal Component Analysis (PCA)](https://en.wikipedia.org/wiki/Principal_component_analysis)
- [Independent Component Analysis (ICA)](https://en.wikipedia.org/wiki/Independent_component_analysis)
- [Non-negative Matrix Factorization (NMF)](https://en.wikipedia.org/wiki/Non-negative_matrix_factorization)

A set of randomly selected image components in natural images are similar to gabor functions, which seem to capture the intrinsic structure of natural images. A set of gabors can represent every image (with sparsity constraint, such as using as few as possible), which is useful for:

- image compression, such as jpeg, to save storage space, where jpeg reconstruct each image as linear combination of set of image components
- image denoising to reconstruct a noisy image with less noise, components do not include noise
- image inpainting to fill-in missing parts in image using a sparse-subset of image components (non-corrupted)

### <a name="4.3" class="anchor"></a> [4.3 Mid-level vision](#4.3)

The mid-level vision process involves grouping elements that belong together (intensities, colors, edges, features) and segmenting elements in groups from each other (differentiate between groups). A top-down approach is grouping elements that are on the same object based on internal knowledge or prior experience, whereas bottom-up approach is grouping elements that are similar based on image properties.

#### <a name="4.3.1" class="anchor"></a> [Gestalt laws](#4.3.1)

An object grouped with another object is influenced by [Gestalt laws](https://en.wikipedia.org/wiki/Principles_of_grouping), bottom-up approach, to increase simplicity or likelihood (note that the border-ownership of an object is decided in V2, which comes after V1):

- proximity, objects close to each other tend to be grouped together
- similarity, objects that are similar tend to be grouped together (shape, colors, size)
- closure, objects resulting in a closure tend to be grouped together (circles, boxes)
- continuity, objects that can continue tend to be grouped together (straight lines, curves, surfaces)
- common fate, objects that have coherent motion tend to be grouped together
- symmetry, objects that form symmetric groups tend to be grouped together (shaped object on black or white background)
- common region, objects within a region tend to be grouped together (signs, labels)
- connectivity, objects that are connected tend to be grouped together (chain, ladder)
- simplicity (or [Prägnanz](https://en.wikipedia.org/wiki/Gestalt_psychology#Pr%C3%A4gnanz), overrides all other), objects tend to be grouped so that the structure is as simple as possible (such as 12 individual dots vs columns, triangle and box stacked on top of each other vs a strange shape)

## <a name="5" class="anchor"></a> [5. Mid-level artificial vision](#5)

*Keywords: feature space, region growing, region merging, k-means clustering method, Hough transform, snakes*

### <a name="5.1" class="anchor"></a> [5.1 Features and feature space](#5.1)

In the context of vision, a feature is used to determine which elements that belong together (individually or combination, based on Gestalt laws), such as location/proximity, color/similarity, texture/similarity, size/similarity, depth, motion/common fate), not separated by contour/common region, and form a known shape (top-down approach). A feature space is a coordinate system with image elements, or features, as points, where similarity is determined by distance between points in the feature space:

- similarity is measured by affinity (similar to gaussian), cross-relation, normalised cross-correlation (NCC), correlation coefficient
- distance is measured by euclidean distance, sum of squared differences (SDD), sum of absolute differences (SAD)

Features can be weighted differently based on relative importance, finding best performance is non-trivial, but can be scaled to make calculations easier, such as within range of 0 and 1.

### <a name="5.2" class="anchor"></a> [5.2 Segmentation](#5.2)

A region-based method for segmentation try to group image elements with similar feature vectors (look similar), such as thresholding (applied to intensity), region growing, region merging, split and merge, k-means clustering, hierarchical clustering, and graph cutting. An edge-based method partition an image based on changes in feature values (intensity discontinuities), such as thresholding (applied to edge detectors), [Hough transform](https://en.wikipedia.org/wiki/Hough_transform) (model-based, fit data to a predefined model), and active contours (also model-based).

#### <a name="5.2.1" class="anchor"></a> [Thresholding](#5.2.1)

Thresholding methods have regions defined by differences in intensity values and feature space is one-dimensional, where $I'(x, y) = 1$ if $I(x, y)$ above threshold, otherwise $I'(x, y) = 0$ (note that results are often missing parts in figure, such as edges with missing pixels, or has unwanted pixels in figure):

- average intensity, plot intensity diagram, find peak, place threshold between peaks
- hysteresis thresholding, define two thresholds, above and below high threshold is background, between thresholds is figure if adjacent to other figure pixels
- set threshold so that fraction of image is figure (if fraction of image with objects is known)
- local thresholding, thresholds applied to blocks of image that is split into regions, local contrast used to determine threshold (useful when image has shadow or changes to illumination)

Morphological operations can be used to clean up results of thresholding, such as neighbor is defined by structuring element (matrix), dilation to expand area of foreground pixels to fill gaps (background pixels that neighbor foreground pixel is changed from 0 to 1), erosion to shrink area of foreground pixels to remove unwanted pixels (bridges, branches, foreground pixels that neighbor background pixel is changed from 1 to 0) and can be used in combination to remove and fill gaps:

- close gap, dilation into erosion (gap is closed, foreground gaps are filled)
- remove noise, use erosion into dilation (gap is opened, background noise is removed)

#### <a name="5.2.2" class="anchor"></a> [**Example:** Region growing](#5.2.2)

1. seed pixel choosen randomly, set region label
2. check unlabelled pixels that are neighbors
	- if whithin similarity threshold to seed, give region label
3. repeat until region is not growing
4. pick another unlabelled seed pixel
5. repeat until all pixels assigned to a region

#### <a name="5.2.3" class="anchor"></a> [**Example:** Region merging](#5.2.3)

1. set unique label to each pixel, or region (note that result depends on order of merging due to averaging merged pixels)
2. compare region properties with neighbor regions
	- if match, merge into a larger region, set label to same, set properties to average
3. continue merging until no more match, mark as final
4. repeat until all image regions are final

#### <a name="5.2.3" class="anchor"></a> [**Example:** Split and merge](#5.2.4)

1. set same label to all pixels, or region (all pixels belong to same region)
2. for each region
	- if all pixels are not similar, split into four regions, set separate labels, repeat until regions are similar (all pixels in regions are similar)
3. for each region, compare with neighbors and merge similar regions, repeat until no more similar regions

### <a name="5.3" class="anchor"></a> [5.3 Clustering](#5.3)

A partitional clustering algorithm divide data into non-overlapping subsets, or clusters, where each data point is in exctly one cluster. A few methods to determine similarity between clusters:

- single-link, distance between clusters is shortest distance between any of its elements
- complete-link, distance between clusters is longest distance between any of its elements
- group-average, distance between clusters is average distance between its elements
- centroid, distance between clusters is distance between average of feature vectors in each cluster (centroid is point in cluster)

#### <a name="5.3.1" class="anchor"></a> [K-means](#5.3.1)

The k-means clustering algorithm assume $k$-clusters as input (work best with equally sized clusters):

1. randomly pick $k$-cluster centres
2. allocate each element to nearest cluster centre
3. compute new cluster centre as mean position of elements in cluster
4. repeat until cluster centres are unchanged (repeat from step 2 until no new allocations)

#### <a name="5.3.2" class="anchor"></a> [Hierarchical](#5.3.2)

Hierarchical clustering produce a set of nested clusters organised as a tree, such as divisive clustering, where data is regarded as single cluster and then recursively split, or agglomerative clustering, where each data point is regarded as cluster and then recursively merged with most similar cluster.
    
- agglomerative clustering
	
	1. each data point is cluster
	2. compute proximity matrix (different approaches to determine distance)
	3. merge two closest clusters, update proximity matrix
	4. repeat step 3 until predefined number of clusters

### <a name="5.4" class="anchor"></a> [5.4 Graph cutting](#5.4)

A feature space can be represented as a graph, $G = (V, E)$, where vertices, $V$, represent image elements (feature vector), edges, $E$, represent connections between pair of vertices, and each edge is the similarity between the two connected elements. A graph cutting process involves:

- finding the optimal partitioning (cutting graph into disjoint subgraphs)
- similarity between subgraphs is minimised, edges that are cut are weak
- similarity within subgraphs is maximised, strong interior links

#### <a name="5.4.1" class="anchor"></a> [Ncuts](#5.4.1)

Normalised cuts (Ncuts) are used to avoid bias towards small subgraphs (cost of cutting graph). Finding set of nodes that produce minimum cut is a NP-hard problem and only approximations are possible for real images, with bias towards partitioning into equal segments.

### <a name="5.5" class="anchor"></a> [5.5 Fitting](#5.5)

Fitting algorithms use mathematical models to represent a set of elements. A model of the outline of an object can be rotated and translated to compare with an image, and used to represent closely fit data points, or line segments, in an image, where data points that fit the model is grouped together.

#### <a name="5.5.1" class="anchor"></a> [Hough transform](#5.5.1)

The Hough transform is useful for fitting lines, where data points vote on which line to belong to (there are often a lot of potential straight lines):

- any point $(x, y)$ in an image could be part of a set of lines that pass through point
- a line has the relationship $r = y\cos(a) - x\sin(a)$
- an accumulator array is used to count $votes$ for each set of parameter values
- can be generalised to fit any shape that can be expressed parametrically

A generalised Hough transform is an extension to express shapes that can not be expressed parametrically:

- using a table to describe location of each edge pixel in shape relative to some reference point (such as centroid)
- for each point in image
    - assume it is at each edge location and vote for location of reference point

#### <a name="5.5.2" class="anchor"></a> [Active contours](#5.5.2)

An active contour algorithm, also called snakes, should produce result that is near the edge and smooth, where a snake is a curve that moves to minimise energy:

- internal energy is determined by shape, bending and stretching increase energy
- external energy is determined by proximity to other image features, large intensity gradients decrease energy.

Minimising the energy of a snake results in a curve that is short, smooth, and close to intensity discontinuities, but only work on shapes that are closed (no gaps), is sensitive to parameters (smooth vs short vs proximity), and dependent on initial position, which are often placed around object manually.

## <a name="6" class="anchor"></a> [6. Correspondence](#6)

*Keywords: occlusion, correspondence methods, Harris corner detector, image pyramid, SIFT, RANSAC*

### <a name="6.1" class="anchor"></a> [6.1 Multiple images](#6.1)

Typically, multiple images are used when multiple cameras take two or more images at same time (such as stereo, recover 3D information), one camera take two or more images at different times (such as video, motion tracking), or for object recognition, such as current image and training images. The [correspondence problem](https://en.wikipedia.org/wiki/Correspondence_problem) refers to the problem of finding matching image elements across different views (need to decide what to search for, intensity, edges). Correspondence require that most scene points are visible in both images and correponding regions must appear similar, some issues might be:

- occlusions, some elements may not have a corresponding element, or not visible
- false matches, several elements are similar
- changing element characteristics, feature values in corresponding images may differ due to lightning (intensity) and viewpoint (size and shape)
- large search space, each element in an image may have many possible matches in another image

#### <a name="6.1.1" class="anchor"></a> [Correlation-based method](#6.1.1)

A correlation-based method try to match image intensities over window of pixels to find correspondence:

- start from raw image intensity values, match image windows, and compare matches using similarity measure for intensity values
    - maximise cross-correlation, normalised cross-correlation, correlation coefficient
    - minimise sum of squared differences, euclidean distance, sum of absolute differences (SAD)
- for each region $r_{1}$ in $I_{1}$, and for each region $r_{2}$ in $I_{2}$ (both regions are same size)
    - compute similarity between $r_{1}$ and $r_{2}$
    - repeat for all regions in $I_{2}$, correspondence point is centre of region with highest similarity, repeat for all regions in $I_{1}$


Correlation-based methods are easy to implement and have dense correspondense map (calculate at all points), but computationally expensive, constant or repetitive regions give false matches, and viewpoints can not be too different.

#### <a name="6.1.2" class="anchor"></a> [Feature-based method](#6.1.2)

A feature-based method find correspondence by matching sparse sets of image features (detect interest points in both images):

- start from image features extracted from preprocessing, match image features, and compare matches using distance between feature descriptions

- for each interest point $ip_{1}$ in $I_{1}$, and for each $ip_{2}$ in $I_{2}$
    - compute similarity between features
    - select point that maximise similarity measure

Feature-based methods are less sensitive to illumination and appearance, computationally cheaper than correlation-based methods (only need to match selected locations instead of every pixel), but have sparse correspondence maps, which is still sufficient for many tasks, and bad with constant or random regions. The choice of interest points is important, where an interest point is typically a corner, so need to detect same point independently in each image (repeatable detector, invariant to scaling, rotation), and need to recognize corresponding points in each image (distinctive descriptor, sufficiently complex to map with high probability).

Typically, corners are selected as interest points and can be detected by computing intensity gradients ($I_{x}$ and $I_{y}$), convolving image with derivative of Gaussian masks, then sum gradients over small area (Gaussian window) around each pixel:

- [Hessian matrix](https://en.wikipedia.org/wiki/Hessian_matrix), often denoted $H$, where $$H = \left[ \begin{array}{cc} \sum I_{x}^{2} & \sum I_{x}, I_{y} \\\\ \sum I_{x}, I_{y} 	& \sum I_{y}^{2}
\end{array} \right]$$
	- find eigenvalues, $h_{1}$ and $h_{2}$, which corresponds to maximum slope of intensity gradient at two orthogonal directions
	- corner is where $\min(h_{1}, h_{2})$ is greater than some threshold

#### <a name="6.1.3" class="anchor"></a> [Harris corner detector](#6.1.3)

The [Harris corner detector](https://en.wikipedia.org/wiki/Harris_corner_detector) is invariant to translation and rotation, partly invariant to illumination and viewpoint, but not invariant to scale. First find Hessian matrix then find $R$:

- $R = \det(H) - k\textrm{tr}(H)^{2}$, or $$R = \sum I_{x}^{2} \sum I_{y}^{2} - \sum (I_{x}, I_{y})^{2} - k \left( \sum I_{x}^{2} + I_{y}^{2} \right)^{2}$$ where $k$ is a constant in range 0.04-0.06 (note that $k$ is empirically determined)
- $R$ is large at corner, negative with large magnitude at edge, and $\|R\|$ is small in flat regions
	- corner is where $R$ is greater than some threshold
    - local maxima of $R$ as interest points

        |   |   |   |   |
        | - | - | - | - |
        | 1 | 2 | 2 | 2 |
        | 0 | 1 | **4** | 3 |
        | 0 | 2 | 2 | 2 |
        | 0 | 1 | 1 | 0 |

	- use non-maximum supression to find local maxima

		|   |   |   |   |
        | - | - | - | - |
        | 0 | 0 | 0 | 0 |
        | 0 | 0 | **4** | 0 |
        | 0 | 0 | 0 | 0 |
        | 0 | 0 | 0 | 0 |

### <a name="6.2" class="anchor"></a> [6.2 Interest points](#6.2)

An image pyramid can be used to detect interest points at different scales (scale invariant interest points). The Harris-Laplacian find local maximum in space and scale, where descriptor (list of features) is small window around interest point, or set of pixel intensity values.

#### <a name="6.2.1" class="anchor"></a> [SIFT](#6.2.1)

A [Scale Invariant Feature Transform (SIFT)](https://en.wikipedia.org/wiki/Scale-invariant_feature_transform) find local maximum using difference of gaussians in space and scale:

- convolve image with DoG mask and repeat for different resolutions (create Laplacian image pyramid)
- detect maxima and minima of difference of Guassian across scale space, keep points with high contrast, keep points with high structure (Harris corner detector but ratio of trace and determinant of Hessian matrix) $$\frac{\textrm{tr}(H)^{2}}{\det(H)} < \frac{(r + 1)^{2}}{r}$$ where $r$ is usually about 10

The descriptor can be found using this method:

1. calculate magnitude and orientation of intensity gradient at all pixels around interest point (using Gaussian smoothed image at scale where interest point is found, approximate using pixel differences) $$\textrm{magnitude} = \sqrt{\left( I_{x_{1}} - I_{x_{2}} \right)^{2} + \left( I_{y_{1}} - I_{y_{2}} \right)^{2}}$$ $$\textrm{orientation} = \arctan \left(\frac{I_{y_{1}} - I_{y_{2}}}{I_{x_{1}} - I_{x_{2}}} \right)$$
2. create histogram of all orientations around the interest point
	- each sample is weighted by gradient magnitude and Gaussian centres on interest point
	- find dominant orientation (peak in histogram) and rotate dominant orientation up
3. create separate histograms for all orientations in sub-windows
	- for example, a 4x4 matrix in 8 orientations gives a 128 element vector (intensity gradient orientations around interest point), where each sample added to each histogram is weighted by gradient magnitude and Gaussian centered on intrest point, and normalised to unit length

### <a name="6.3" class="anchor"></a> [6.3 Matching](#6.3)

A match that is correct belong to inliers, incorrect are outliers, and used to extract features (feature-based methods), compute matches, find the most likely transformation (most inliers and fewest outliers).

#### <a name="6.3.1" class="anchor"></a> [RANSAC](#6.3.1)

[RANSAC](https://en.wikipedia.org/wiki/Random_sample_consensus), which is a random sample consensus algorithm, can be used to fit model to data set with outliers, where data consist of inliers and outliers, and parameterized model explains inliers:

1. randomly pick minimal subset of data points (sample)
2. fit model to subset
	- test all other data points to determine if consistent with fitted model, such as distance $t$ to model prediction
	- count number of inliers (this is the consensus set)
	- size of consensus set is model support
3. repeat $n$-times
	- select model parameters with higest support and re-estimate model with points in subset

RANSAC is simple and effective, works with different model fitting problems, such as segmentation, camera transformation, and object trejectory, but can sometimes requires many iterations with a lot of parameters, which can be computationally expensive.

## <a name="7" class="anchor"></a> [7. Stereo and depth](#7)

*Keywords: 3D scene points, disparity, epipolar constraints, depth*

### <a name="7.1" class="anchor"></a> [7.1 Stereo vision](#7.1)

A camera projects a 3D point onto 2D plane, so all 3D points on the same line-of-sight has the same 2D image location, so depth information is lost,

$$x' = \frac{f'}{Z_{1}} X_{1} = \frac{f'}{Z_{2}} X_{2}$$

A stereo image (two images), can be used to recover depth information, where points project to same location in one image but to different locations in the other image. Two images can be used to measure how far each point are from each other in each image (different viewpoint, need to solve correspondence problem). This is useful for:

- path planning and collision avoidance
- virtual advertising
- 3D model building from 2D images (such as in google maps)

Image formation with one camera is a 3D scene point, $P$, projected to point on image, $P'$, so

$$P' = (x', y') = \left( f\frac{x}{z}, f\frac{y}{z} \right)$$ 

Image formation with two cameras (stereo) is a 3D scene point projected to $(x_{R}', y_{R}')$ and $(x_{L}', y_{L}')$, so

$$(x_{L}', y_{L}') = \left( f\frac{x}{z}, f\frac{y}{z} \right)$$

$$(x_{R}', y_{R}') = \left( f\frac{x - B}{z}, f\frac{y}{z} \right)$$

where $B$ is baseline, or distance between cameras, $x_{R} = x_{L} - B$.

#### <a name="7.1.1" class="anchor"></a> [Disparity](#7.1.1)

Disparity, denoted as $d$, is difference between coordinates of two corresponding points (2D vector). A pair of stereo images define a field of disparity vectors, or disparity map, and coplanar cameras has disparity in $x$-coordinates only, where

$$d = x_{L}' - x_{R}' = f\frac{x}{z} - f\frac{x - B}{z} = f\frac{B}{z} \Rightarrow z = f\frac{B}{d}$$

- disparity is measured by finding corresponding points in images
    - correlation-based methods gives dense disparity maps (disparity value at each pixel)
    - feature-based methods gives sparse disparity maps (disparity value at interest points only)
- if baseline distance is known, measure disparity and calculate depth of point
- if basline distance is not known, calculate relative depths of points from relative disparities

### <a name="7.2" class="anchor"></a> [7.2 Coplanar cameras](#7.2)

An epipolar constraint is cameras on the same plane, $y_{L}' = y_{R}'$, so possible to search along straight line to find corresponding point in other image, and maximum disparity constraint is when length of search region depends on maximum expected disparity, so $$d_{\textrm{max}} = f\frac{B}{z_{\textrm{max}}}$$

- for each point $(x', y')$ in image
    - search correponding point between $(x' - d_{\textrm{max}}, y')$ and $(x' + d_{\textrm{max}}, y')$ in other image

Other constraints are:

- continuity constraint, neighbouring points have similar disparities, or relative distance between different corresponding points the same
- uniqueness constraint, location in image should only match single point in other image
	- exception is line-of-sight
- ordering constraint, matching points along corresponding epipolar (straight line) is same order in images
	- exception is difference in depth

#### <a name="7.2.1" class="anchor"></a> [FOV](#7.2.1)

A field of view (FOV) is points in image visible to camera, where one camera has one FOV and two cameras have two FOV, and one common FOV visible to both cameras (coplanar):

- short baseline gives large common FOV and large depth error, where changes in depth result small changes in disparity
- long baseline gives small common FOV and small depth error, where changes in depth result large changes in disparity

### <a name="7.3" class="anchor"></a> [7.3 Non-coplanar cameras](#7.3)

Non-coplanar cameras are when cameras are at different planes with intersecting optical axes, which gives large common FOV and small depth error, fixation point determined by convergence angle (note that corresponding points still occur on straight lines, or epipolar lines, but not strictly horizontal, so search can be reduced to line):

- disparity is measured using angles instead of distance, $a_{L} - a_{R}$, and is zero at fixation point and zero at points on curve where equal angles intersect ([horopter](https://en.wikipedia.org/wiki/Horopter), or zero-disparity curve)
- magnitude increase with distance from horopter and need to be consistent with signs and order, so outside if $a_{L} - a_{R} > 0$ and inside if $a_{L} - a_{R} < 0$

#### <a name="7.3.1" class="anchor"></a> [Epipolar geometry](#7.3.1)

In epipolar geometry:

- baseline is line through camera projection centres
- epipole is projection of optic centre of one camera in the image plane of the other camera
- epipolar plane is plane going through a particular 3D point and optic centres of both cameras
- epipolar lines is intersection of epipolar plane and each image plane
- conjugated epipolar lines is epipolar lines generated by the same 3D point in both image planes
- epipolar constraints, corresponding points must be on conjugated epipolar lines

A rectification is a transform to make epipolar lines parallel to rows of an image and warps both images so all epipolar lines are horizontal (free transform to treat as coplanar cameras).

#### <a name="7.3.2" class="anchor"></a> [Recognising depth](#7.3.2)

Depth in images can be recognised using different methods:

- interposition, view of one object is interrupted by another object (relative depth)
    - manipulating interposition can produce impossible objects, such as [penrose triangle](https://en.wikipedia.org/wiki/Penrose_triangle) and kanizsa square
- size familiarity, different sizes of same object appear closer or further away
- texture gradients, uniformly textured surfaces get smaller and closely spaced at distance (tiles, waves)
- linear perspective, property of parallel lines converging at infinity
    - manipulating perspective can produce unusual perceptions, such as street 3D paintings and [Trompe L'oeil](https://en.wikipedia.org/wiki/Trompe-l%27%C5%93il) art
- aerial perspective, scattering of light by particles in the athmosphere, where distant objects look less sharp, lower contrast, and lower color saturation
- shading, distribution of light and shadow on objects (usually light comes from above)
- motion parallax, objects closer than fixation point appear to move opposite to observer, and further away move in same direction (twisting)
- optic flow, camera moving forward or backward and pattern of stimulation across visual field changes, where points closer to camera move faster
- accretion and deletion, parts of object appear and disappear as observer moves relative to two surfaces at different depths
- structure from motion (kinetic depth), movement of object or camera can induce perception of 3D structure (spinning cylinder in flat image)

## <a name="8" class="anchor"></a> [8. Video and motion](#8)

*Keywords: optic flow vector, aperture problem, track algorithm, image differencing, background subtraction*

### <a name="8.1" class="anchor"></a> [8.1 Optic flow](#8.1)

A video is a series of $n$-images, also referred to as frames, at discrete time instants. A static image has intensity of pixel as function of spatial coordinates $x$, $y$, so $I(x, y)$, whereas a video has intensity of pixel as function of spatial coordinates $x$, $y$ and time $t$, so $I(x, y, t)$. An optic flow is change in position from one image to another image, optic flow vector is the image motion of a scene point, and optic flow field is collection of all optic flow vectors, which can be sparse or dense (defined for specified features or defined everywhere). An optic flow provides an approximation of a motion field, true image motion of a scene point from actual projection of relative motion between camera and 3D scene, but not always accurate (smooth surfaces, moving light source). It is measured by finding corresponding points at different frames (note that a discontinuity in an optic flow field indicate different depths, so different objects):

- feature-based methods extract features from around point to find similar features in next frame (similar to stereo correspondence)
	- sparse optic flow field
	- suitable when image motion is large
- direct methods recover image motion at each pixel from temporal variations of image brightness (convolve image with spatio-temporal filters)
	- dense optic flow field
	- sensitive to appearance variations
	- suitable when image motion is small

Constraints for finding corresponding points in video:

- spatial coherence, similar neighbouring flow vectors are preferred over dissimilar, assuming scene points are smooth surfaces and closer points more likely to belong to same surface
- small motion, small optic flow vectors are preferred over large, assuming relative velocities are slow compared to frame rate and motion between frames is likely small compared to size of image

An optic flow is measured to estimate layout of environment, such as depth and orientation of surfaces, estimating ego motion (camera velocity relative to visual frame of reference), estimating object motion relative to visual frame of reference or environment frame of reference, and to predict information for control of action. The [aperture problem](https://en.wikipedia.org/wiki/Motion_perception#The_aperture_problem) is the inability to determine optic flow along direction of brightness pattern (no edges or corners along straight lines), where any movement with a component perpendicular to an edge is possible. It is solved by combining local motion measurements across space.

#### <a name="8.1.1" class="anchor"></a> [**Example:** recovering depth (perpendicular)](#8.1.1)

Below is an example of recovering depth from velocity if direction of motion is perpendicular to optical axis and velocity of camera is known:

- $x = f\frac{X}{Z}$, $Z = f\frac{X_{1}}{x_{1}} = f\frac{X_{2}}{x_{2}}$ and $x = \frac{x_{2} - x_{1}}{t}$
	
	- $X_{1}x_{2} = X_{2}x_{1}$
	- $X_{1}x_{2} = (X_{1} - Vt)x_{1}$
	- $X_{1} (x_{2} - x_{1}) = -Vtx_{1}$
	- $X_{1} = -\frac{Vx_{1}}{x}$
	- $Z = f\frac{X_{1}}{x_{1}} = -f\frac{V}{x}$

#### <a name="8.1.2" class="anchor"></a> [**Example:** recovering depth (along optical axis)](#8.1.2)

Below is an example of recovering depth from velocity if direction of motion is along optical axis and velocity of camera is known:

- $x = f\frac{X}{Z}$, where $fX = x_{1} Z_{1} = x_{2} Z_{2}$ and $x = \frac{x_{2} - x_{1}}{t}$

	- $x_{1} (Z_{2} + Vt) = x_{2} Z_{2}$
	- $x_{1}Vt = (x_{2} - x_{1})Z_{2}$
	- $Z_{2} = \frac{Vx_{1}}{x}$

#### <a name="8.1.3" class="anchor"></a> [**Example:** recovering depth (unknown velocity of camera)](#8.1.3)

Below is an example of recovering depth from velocity if direction of motion is along optical axis and velocity of camera is not known (time-to-collision if velocity is constant, used by birds to catch prey and land without crashing into surfaces):

- $Z_{2} = \frac{Vx_{1}}{x}$
	
	- $\frac{Z_{2}}{V} = \frac{x_{1}}{x}$
	- $\frac{x_{1}}{x} = \frac{a_{1}}{a} = \frac{2A_{1}}{A}$, where $a$ is angle subtended by object and $A$ is area of objects image

#### <a name="8.1.4" class="anchor"></a> [Parallel and radial optic fow fields](#8.1.4)

A parallel optic flow field, where depth velocity is zero, is when all optic flow vectors are parallel, direction of camera movement is opposite to direction of optic flow field, speed of camera movement is proportional to length of optic flow vectors, and depth is inversely proportional to magnitude of optic flow vector (similar to motion parallax with fixation on infinity).

A radial optic flow field, where depth velocity is not zero, is when all optic flow vectors point towards or away from vanishing point, direction of camera movement is determined by focus of expansion or focus of contraction, destination of movement is focus of expansion, depth is inversely proportional to magnitude of optic flow vector and proportional to distance from point to vanishing point.

#### <a name="8.1.5" class="anchor"></a> [Track algorithm](#8.1.5)

An optic flow algorithm, such as [track algorithm](https://en.wikipedia.org/wiki/Track_algorithm), is matching high-level features across several frames to track objects. It uses previous frames to predict location in next frame (Kalman filter, Particle filter) to restrict search and do less work. Measurement noise is averaged to get better estimates, where an object matched to location should be near predicted location.

### <a name="8.2" class="anchor"></a> [8.2 Video segmentation](#8.2)

Segmentation from motion is typically done using optic flow discontinuities, optic flow and depth, or Gestalt law of common fate:

- image differencing is the process of subtracting pixel by pixel from next frames to create a binary image (absolute difference above threshold), intensity levels change the most in regions with motion, so if $I(x, y, t)$ and $I(x, y, t + 1)$, then $$\|I(x, y, t + 1) - I(x, y, t)\| > T$$ where $T$ is some threshold (note that it is not optimal when background matches object, or for smooth objects)
- background subtraction is when background is used as reference image (static image) and each image is subtracted from previous image in sequence, adjacent frame difference, which is similar to image differencing $$B(x, y) = I(x, y, t - 1)$$
    - off-line average, pixel-wise mean values computed in separate training phase, also called mean of threshold $$B(x, y) = \frac{1}{N} \sum I(x, y, t)$$
    - moving average, background model is linear weighted sum of previous frames and is commonly used $$B(x, y) = (1 - \beta) B(x, y) + \beta I(x, y, t)$$

#### <a name="8.2.1" class="anchor"></a> [Background subtraction](#8.2.1)

In background subtraction, new objects that are temporarily stationary is seen as foreground, dilation and erosion can be used to clean result, so if $B(x, y)$ and $I(x, y, t)$, then $\|(I(x, y, t) - B(x, y)\| > T$, where $T$ is some threshold:

1. for each frame $t = 1 .. N$
    - update background model, $B(x, y) = (1 - \beta) B(x, y) + \beta I(x, y, t)$
2. compute frame difference $\|I(x, y, t) - B(x, y)\|$, where threshold frame difference is $\* > T$
3. remove noise, $\textrm{close}(\*\_{T})$

## <a name="9" class="anchor"></a> [9. Artificial recognition](#9)

*Keywords: object identification, object localisation, template matching, sliding window method, edge-matching, intensity histograms, ISM, bag-of-words, invariants*

### <a name="9.1" class="anchor"></a> [9.1 Object recognition tasks](#9.1)

An object recognition task is often to determine the identity of an individual instance of an object, such as recognising different phone models, or people. A classification task is to determine category of an object, such as human vs ape, or phone vs calculator, where each category has a different level:

- abstract categories are objects, such as animal, man-made, and mammal
- basic level is lowest level where objects have distinct features (apple or banana is easier than Rex vs Annie), humans are fast at recognising objects in category and start at basic level categorisation before identification
- specific categories are names, such as poodle, doberman, Rex, and Annie

A localisation task determine presence and location of an object in image, such as finding faces and cars, where image segmentation is used to determine location of multiple different objects in image (semantic segmentation). Object recognition should be sensitive to small image differences relevant to different categories of objects (phone vs calculator) and insensitive to large image differences that do not affect the identity or category of object (mobile phone vs old phone), such as background clutter and occlusion, viewpoint, lightning, non-rigid deformations (same object changing shape, wind blowing in tree), or variation within category (different type of chairs).

Note that it is generally hard to distinguish between similar objects (many false positives), and global representation is sensitive to viewpoint and occlusion (many false negatives), so one approach to object recognition is to use intermediate complexity between local and global, or hierarchy of features with range of complexities, or sensitivity.

### <a name="9.2" class="anchor"></a> [9.2 Object recognition process](#9.2)

The object recognition process is to associate information extracted from images with objects, which requires accurate image data, representations of objects, and some matching technique:

- extract representations from training examples, local vs global features, 2D vs 3D, pixel intensities vs other features
- extract representation from image and match with training examples to determine category or identity, top-down vs bottom-up, measure of similarity, classification criteria

Note that an image can be represented as:

- pixel intensities, feature vectors, or geometry
- 2D (image-based), 3D (object-based)
- local features, global features

The most common methods used for object recognition are sliding window, ISM, SIFT, and bag-of-words, where matching procedures are:

- top-down, which is generative and expectation-driven
	- model object to find in image, such as model-based methods, templates, and edge matching
- bottom-up, which is discriminative and stimulus-driven
	- extract description and match to descriptions in database, such as SIFT, bag-of-words, intensity histograms, and ISM

#### <a name="9.2.1" class="anchor"></a> [Template matching](#9.2.1)

[Template matching](https://en.wikipedia.org/wiki/Template_matching) is a general technique for object recognition, where image of some object to be recognized is represented as a template, which is an array with pixel intensities (note that template needs to be very similar to target object, so not scaled or rotated, and is sensitive to occlusion):

1. search each image region
2. calculate similarity between template and image region using similarity measures
    - pick best match or above threshold

#### <a name="9.2.2" class="anchor"></a> [Sliding window](#9.2.2)

A sliding window method is a template matching method with a classifier for each image region, where each image region is warped to increase tolerance to changes in appearance. The classifier, which could be a deep neural network (CNN), then determines if image region contains the object instead of simple intensity value comparison. However, it is very computationally expensive (pre-processing using image segmentation can reduce number of image regions to classify, sky not likely to have cows in it).

#### <a name="9.2.3" class="anchor"></a> [Edge-matching](#9.2.3)

In edge-matching, an image of some object is represented as a template, which is pre-processed to extract edges:

1. search each image region
    - calculate average minimum distance between points on edge template, $T$, and points on edge image, $I$, so $$D(T, I) = \frac{1}{T} \sum d_{1}(t)$$
    - minimum value is best match.

#### <a name="9.2.4" class="anchor"></a> [Model-based methods](#9.2.4)

A model-based method is model of object identity and pose, where object is rendered in image, or back-project, and compared to image (edges in model match edges in image). It is represented as 2D or 3D model of object shape, and compared using edge score, image edges near predicted object edges (unreliable), or oriented edge score, image edges near predicted object edges with correct orientation. It is very computationally expensive.

#### <a name="9.2.5" class="anchor"></a> [Intensity histogram](#9.2.5)

A intensity histogram method is histogram of pixel intensity values (grayscale or color) representig some object, color histograms are commonly used in face detection and recognition algorithms. Histograms are compared to find closest match, which is fast and east to compute, and matches are insensitive to small viewpoint changes. However, it is sensitive to lightning and within-category changes to appearance, and insensitive to spatial configuration, where image with similar configurations result in same histogram.

#### <a name="9.2.6" class="anchor"></a> [ISM](#9.2.6)

An implicit shape model (ISM) method is where 2D image fragments, or parts, are extracted from image regions around each interest point (Harris detector):

- image fragments can be collected from training images and clustered into sets with similar image regions (use cluster centre as key)
- image fragments match set features to training images using template matching, where each set feature find possible object centres (features on car points towards middle)
- find interest points in input image, match extracted features with features in set, and then matched features vote on object centre

#### <a name="9.2.7" class="anchor"></a> [Feature-based methods](#9.2.7)

A feature-based method is when training image content is transformed into local features, so invariant to translation, rotation, and scale. Local features is extracted from input image and then features are matched with training image features. In SIFT feature matching, a 128 element histogram of orientations of intensity gradients is binned into 8 orientations and 4x4 pixel windows around the interest point, normalised with dominant orientation vertical:

- locality, features are local and insensitive to occlusion and clutter, distinctiveness, features can be matched to database of objects, quantity, many features can be generated for small objects, and efficiency, close to real-time performance
- set of interest points obtained from each training image, each has descriptor (128 components), all sets stored in database with key as interest point
- input image gives new set of interest points and descriptor pairs, then for each pair, find two best matching descriptors in database, match if ratio of distance to first nearest descriptor to second within some threshold (can use RANSAC to determine if matches are consistent)

#### <a name="9.2.8" class="anchor"></a> [Bag-of-words](#9.2.8)

A [bag-of-words](https://en.wikipedia.org/wiki/Bag-of-words_model) method is when different objects have distinct set of features that occur in different frequencies:

- find interest points using regular grid, interest point detectors, or randomly, then extract descriptor from image regions around interest points (also referred to as words)
- object have a distribution of feature occurrences, or histogram, and cluster descriptors can be used to find cluster centre (word stem, set of clusters represent vocabulary), where most frequent words that occur in most images are removed
- input image is matched by comparing distance between histograms

### <a name="9.3" class="anchor"></a> [9.3 Geometric invariants](#9.3)

A geometric invariant is some property of an object in a scene that do not change with viewpoint (note that geometric invariant methods compare values of cross-ratio in image with cross-ratios in training images, but sensitive to occlusion and availability and distinctiveness of points):

- in Euclidean space, which include translation and rotation, invariants are lengths, angles, and areas
- in similarity space, which include translation, rotation, and scale, invariants are ratios of length and angles
- in affine space, which include translation, rotation, scale, and shear,  invariants are parallelism, ratios of lengths along lines, and ratio of areas
- in projective space, which include translation, rotation, scale, shear, and foreshortening, invariants are cross-ratio, which is ratio of ratios of lengths, and is constant from any viewpoint $$\frac{\| P3 - P1 \| \| P4 - P2 \|}{\| P3 - P2 \| \| P4 - P1 \|}$$

## <a name="10" class="anchor"></a> [10. Biological recognition](#10)

*Keywords: object-based theory, image-based theory, cortical visual system, feedforward model, HMAX, Bayes Theorem*

### <a name="10.1" class="anchor"></a> [10.1 Object recognition theories (psychology)](10.1)

In object-based theory, or [recognition-by-components](https://en.wikipedia.org/wiki/Recognition-by-components_theory), each object is represented as 3D model with an object-centered reference frame, objects are stored in our brain as structural descriptions (parts and configuration), and each object is a collection of shapes (or geometric components), such as human head and body could be represented as a cube shape above cylinder shape.

Geometric components are primitive elements (or geons, letters forming words), such as cube, wedge, pyramid, cylinder, barrel, arch, cone, expanded cylinder, handle, expanded handle, and different combinations of goens can be used to represent a large variety of objects:

- each geon is sufficiently different from each other, so robust to noise and occlusion, view-invariant (same set of geons in same arrangement in different views)
- objects can be matched by finding elements and configuration
	- parse image into geons
	- determine relative location and size, or match with stored structural descriptions

#### <a name="10.1.1" class="anchor"></a> [Image-based theory](#10.1.1)

In image-based theory, each object is represented by multiple 2D views with a viewer-centered reference frame and matched using template matching, which is an early version of an image-based approach (less flexible compared to human recognition), or multiple views approach, which encode multiple views of an object through experience (templates for recognition).

#### <a name="10.1.2" class="anchor"></a> [Classification](#10.1.2)

To assign objects to different categories of features in a feature space, or classification, where category membership is defined by abstract rules (such as "has three sides, four legs, and barks"):

- prototypes, calculate average for all instances in each category, where each new instance is compared and assigned to nearest one (nearest mean classifier, decision boundary is linear)
    - for each category (or label)
        - calculate mean of feature for all training examples in category
    - for each new instance (or stimulus)
        - find closest prototype and assign instance to that label
- exemplars, specific instances in each category are stored as exemplars, where each new instance is compared and assigned to nearest one (nearest neighbour classifier), or best match
    - for each new instance
        - find closest exemplar
        - assign instance to that category label
    - alternatively, for each new instance
        - find $k$-nearest exemplars (such as [k-nearest neighbours classifier](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm))
        - assign instance to category label of majority ($k$ small and odd to break ties)

A nearest neighbour classifier have a non-linear decision boundary and do not deal with outliers. The k-nearest neighbours classifier also have a non-linear decision boundary but reduce effect of outliers. To determine similarity (using similarity measures):

- minimum distance measures
	- sum of squared differences (SSD)
	- Euclidean distance
	- sum of absolute differences (SAD)
	- Manhattan distance
- maximum similarity measures
	- cross-correlation
	- normalised cross-correlation
	- correlation coefficient

### <a name="10.2" class="anchor"></a> [10.2 Cortical processing (neuroscience)](#10.2)

In the cortical visual system, there are pathways for different kinds of information, such as spatial and motion (the where and how), which goes from V1 to parietal cortex, or identity and category (the what), which goes from V1 to inferotemporal cortex. The receptive fields become greater further down a pathway, similar to a heirarchy, or progression:

- centre-surround cells, such as in the eye, respond to isolated spots of contrasting intensity
- simple cells, such as LGN, respond when multiple co-aligned centre-surround cells are active, and to edges and bars at a specfic orientation, contrast, and location
- complex cells, such as V1, respond when multiple similarly oriented simple cells are active and to edges and bars at specific orientation, but any contrast and location

#### <a name="10.2.1" class="anchor"></a> [Feedforward model](#10.2.1)

A feedforward model is image processed by layers of neurons with progressively more complex receptive fields, and at progressively less specific locations, where features at one stage is built from features at earlier stages (heirarchical). [Hierarchical max-pooling (HMAX)](https://maxlab.neuro.georgetown.edu/hmax.html) is a deep neural network with different mathematical operations required to increase complexity of receptive fields, where multiple models use alternating layers of neurons with different properties, such as $\textrm{simple}(S)$ and $\textrm{complex}(C)$. The simple cells are sums (similar to logical $and$ operation) and used to increase selectivity, whereas complex cells are max (similar to logical $or$ operation) and used to increase invariance. A [convolutional neural network (CNN)](https://en.wikipedia.org/wiki/Convolutional_neural_network) is a deep neural network similar to HMAX, but alternating layers with convolution and sub-sampling.

### <a name="10.3" class="anchor"></a> [10.3 Bayesian inference](#10.3)

A recurrent model of cortial hierarchy is when bottom-up and top-down information interact to affect perception (information from higher cortical regions to primary sensor areas), where bottom-up processes, use information in stimulus to aid in identification (stimulus-driven) and top-down processes use context, or previous knowledge, and expectation to aid in identification (knowledge-driven).

#### <a name="10.3.1" class="anchor"></a> [Bayes Theorem](#10.3.1)

The [Bayes Theorem](https://en.wikipedia.org/wiki/Bayes%27_theorem) describe an optimal method to combine bottom-up and top-down information, so what we see is inferred from both the sensory input data and our prior experience. In conditional probability, $$\textrm{P}(A\|B) \textrm{P}(B) = \textrm{P}(B\|A) \textrm{P}(A)$$ and $$\textrm{P}(A\|B) = \textrm{P}(B\|A) \frac{\textrm{P}(A)}{\textrm{P}(B)}$$ such as $\textrm{P}(rain\|wet grass) < 1$, or rain given wet grass is not guaranteed, and $\textrm{P}(wet grass\|rain) = 1$, or rain always gives wet grass:

- probability that object is present in world given image in retina, this is an inverse problem and hard
	- $\textrm{P}(object\|image)$
- probability that image is observed given 3D object, this is a forward problem and easier
	- $\textrm{P}(image\|object)$, so $$\textrm{P}(object\|image) = \textrm{P}(image\|object) \frac{\textrm{P}(object)}{\textrm{P}(image)}$$ where posterior is likelihood times prior divided by evidence, where posterior is something we want to know, likelihood is something we already know, prior is something we know from prior experience, and evidence is something we can ignore
