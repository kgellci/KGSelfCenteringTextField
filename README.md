KGSelfCenteringTextField
========================

Subclass KGSelfCenteringTextField or change the class of any of your textfields to KGSelfCenteringTextField and they should automatically search for the scrollView which they are within.  Once the scrollView is found by the textField, the textField will then attempt to figure out at which position it should offset the scrollView so that it is centered.  The textField will only center itself as long as there is enough content size, otherwise it will move to the max allowed by the contentSize.

The contentSize of the scrollView should be adjusted by the viewController to account for the keyboard appearing prior to they textfield being centered.  Open the project and take a look at KGViewController as an example of how this is accomplished.
