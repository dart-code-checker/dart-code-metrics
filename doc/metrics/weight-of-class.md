# Weight Of a Class

Number of **functional** public methods divided by the total number of public methods.

This metric tries to quantify whether the measured class (_mixin_, or _extension_) interface reveals more data than behaviour. Low values indicate that the class reveals much more data than behaviour, which is a sign of poor encapsulation.

Our definition of **functional** method excludes getters and setters.
