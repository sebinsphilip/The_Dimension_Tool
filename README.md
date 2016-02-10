# THE DIMENSION TOOL
### TASK:
To develop an iPhone application, which can be used to measure the dimensions of an
object by taking its photo/video through the inbuilt camera.
### PROJECT DETAILS:
The Dimension Tool is used to measure the height and width of the smallest box that a
particular object can fit into. It requires one input­ the lens’ height from the base of the object, the
only constraint being that the object must be on the same plane as the one on which the user
stands.

          The user is asked to point to the object’s base and then to the object’s top.

![alt tag](https://cloud.githubusercontent.com/assets/633728/12955817/d90cb706-d04a-11e5-8a39-f2986c1282a9.png)

         ( Fig a)                                              ( Fig b)

The object has to then be fitted into a frame. Based on the dimensions on screen and the
height computed before, the width can also be computed and the two dimensions are displayed
along the frame’s side and bottom. Once this is done, the user can also measure the height and
width of any object at the same distance from the user as the initial object.


![alt tag](https://cloud.githubusercontent.com/assets/633728/12955836/f251f6ae-d04a-11e5-941b-5ed4f730a16d.png)

         ( Fig c)                                              ( Fig d)


### TECHNICAL DETAILS:

>IDE : Xcode 6.0.

>Language : Objective C.

>Frameworks : CoreMotion, Foundation, MediaPlayer, QuartzCore, UIKit.

### APPLICATION’S LOGIC:

The Dimension Tool utilizes the principles of trigonometry in almost all of its
computations. Initially the user gives the lens’ height as input. This gives one side (the
perpendicular) of a right angled triangle. Using the device’s inbuilt gyroscope, the pitch and
hence an angle of the same right angled triangle is obtained.

![alt tag](https://cloud.githubusercontent.com/assets/633728/12955960/816e10f2-d04b-11e5-87aa-89d0470d34f6.png)

Using these two values, the base of the triangle can be computed by the formula:
base= tan(angle) * perpendicular
This base is the distance to the object.
To find the object height, there are two cases we must consider:

>a. when the object is smaller than the user; and

>b. when the object is larger than the user.

These two cases are differentiated by using the another property of the gyroscope­the
yaw.

If the object is smaller than the user, the user does not tilt the phone more than 90
degrees.Also the sign of yaw doesn’t change when the lens points to the base and then to the
top, its values are either both positive or both negative.

If the object is larger than the user, the device is tilted through any angle between 90
degrees and 180 degrees and the yaw changes sign, i.e. if it is positive when the device points
to the base, it will be negative when it points to the top and vice versa.

This enables us to categorise the object as being either larger or smaller than the user.
> ## A. When the object is smaller than the user:

Now, when the user tilts the phone from the base to point to the top of the object (with
least possible change in position of the device), a new angle(“angle2”) is obtained as shown
below:

![alt tag](https://cloud.githubusercontent.com/assets/633728/12955963/87fcb8c4-d04b-11e5-87a0-dc339d944d5d.png)

From the figure, the smaller right angled triangle can now give us the value of ‘d’, which is the
difference in height between the user and the object, using the formula:

>d = distance / tan (angle2)

where distance is the base as obtained from previous calculations.
Now the height of the object can be obtained by substituting in the equation:

>object’s height = lens’ height - d

## B. When the object is larger than the user:
In this case too, the final angle made by the device with the vertical, when the user tilts it to point
to the top of the object from its base, is recorded and used to compute the difference in height
again, but this difference is added to the height given as input by the user.

As the gyroscope always returns acute angles, in this case, angle2 is defined as shown
below:

![alt tag](https://cloud.githubusercontent.com/assets/633728/12955971/8ca7d62e-d04b-11e5-879e-b872379df08c.png)

                      From the figure,
                            tan (90 - angle2) = d / distance
                             Hence d = distance * tan (90 - angle2)
                             Or d = distance * cot (angle2)
Again ‘d’ is found to be distance / tan (angle2) .

This difference is added to the input height as follows to give:

           object’s height = lens’ height + d

Thus we now have the object’s height.

To find out the width, the user is asked to adjust the frame present on-screen (refer
frame in Fig d) to fit correctly around the object as viewed through the lens. From the height and
width of the frame on the device screen, we obtain a reference ratio of the height of the object’s
image on screen to the object’s real height. It is known that this ratio is the same as the ratio of
the width of the object on screen to the real width of the object. Thus the width of the object can
be obtained as:

         width(real) = { height (real) / height (on-screen) } * width (on-screen)
This width and the previously obtained height are then displayed along the frame bottom
and side respectively.

Once the frame is labelled with the correct object dimensions, the dimensions of any
object at the same distance from the user as the initially measured object can be found by
adjusting the frame to fit the new object on-screen. The frame’s dimensions dynamically change
thereby showing the dimensions of the new object.

### FUTURE EXPANSION AND FEATURES:


The Dimension Tool has a promising future. On making a few tweaks and modifications,
this application could be used to measure the 3 dimensions of any object lying on the same
horizontal plane as the user. The frame viewed on-screen can be modified to be three
dimensional (assuming a default cubic structure) and the object, may it be tilted or straight, can
be made to fit into this frame. The frame can be made adjustable in length, breadth, height and
angle to fit around the object correctly thereby capable of returning the 3 dimensions of the
object.


The process as seen by the user, to obtain this, will be the same as that to obtain 2
dimensions of an object. Additional changes are made only in the code to include a 3
dimensional frame and a factor by which the 3rd dimension can also be obtained from this new
frame.
