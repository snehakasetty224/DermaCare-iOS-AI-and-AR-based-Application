var World = {
loaded: false,
    
init: function initFn() {
    this.createOverlays();
},
    
createOverlays: function createOverlaysFn() {
    /*
     First an AR.ImageTracker needs to be created in order to start the recognition engine. It is initialized with a AR.TargetCollectionResource specific to the target collection that should be used. Optional parameters are passed as object in the last argument. In this case a callback function for the onTargetsLoaded trigger is set. Once the tracker loaded all its target images, the function worldLoaded() is called.
    
     */
    this.targetCollectionResource = new AR.TargetCollectionResource("assets/double.wtc", {
                                                                    });
    
    this.tracker = new AR.ImageTracker(this.targetCollectionResource, {
                                       onTargetsLoaded: this.worldLoaded,
                                       onError: function(errorMessage) {
                                       alert(errorMessage);
                                       }
                                       });
    
    /*
     The next step is to create the augmentation. In this example an image resource is created and passed to the AR.ImageDrawable. A drawable is a visual component that can be connected to an IR target (AR.ImageTrackable) or a geolocated object (AR.GeoObject). The AR.ImageDrawable is initialized by the image and its size. Optional parameters allow for position it relative to the recognized target.
     */
    
    // Create overlay for page one TRIAL 
    var newRash = new AR.Label("Wait for few more days", .2, {
                               zOrder: 1,
                               translate: {
                               y: -0.15
                               },
                               style: {
                               // change text and color here
                               backgroundColor: '#6699ff',
                               textColor: '#ffffff',
                               fontStyle: AR.CONST.FONT_STYLE.BOLD
                               }
                               });
    
    var htmlWidgetwait = new AR.HtmlDrawable({
                                            uri: "assets/wait.html"
                                            }, 1.0, {
                                            viewportWidth: 320,
                                            viewportHeight: 300,
                                            backgroundColor: "#FFFFFF",
                                            translate: { x: 0.36, y: 0.5 },
                                            horizontalAnchor: AR.CONST.HORIZONTAL_ANCHOR.RIGHT,
                                            verticalAnchor: AR.CONST.VERTICAL_ANCHOR.TOP,
                                            opacity : 0.7
                                            });

    /*
     This combines everything by creating an AR.ImageTrackable with the previously created tracker, the name of the image target as defined in the target collection and the drawable that should augment the recognized image.
     Note that this time a specific target name is used to create a specific augmentation for that exact target.
     */
    var pageOne = new AR.ImageTrackable(this.tracker, "newrash", {
                                        drawables: {
                                        cam: htmlWidgetwait
                                        },
                                        onEnterFieldOfVision: function onEnterFieldOfVisionFn() {
                                        soundwait.load();
                                        },
                                        onImageRecognized: this.removeLoadingBar,
                                        onError: function(errorMessage) {
                                        alert(errorMessage);
                                        }
                                        });
    
    var soundwait = new AR.Sound("assets/wait.mp3", {
                                 onLoaded : function(){soundwait.play();},
                                 onError : function(){
                                 // alert the user that the sound file could not be loaded
                                 },
                                 });

    
    /*
     Similar to the first part, the image resource and the AR.ImageDrawable for the second overlay are created.
     */
    //TRIAL
    var mildRash = new AR.Label("Mild Rash, Apply Ointment", .2, {
                                  zOrder: 1,
                                  translate: {
                                  y: -0.15
                                  },
                                 style: {
                                 // change text and color here
                                 backgroundColor: '#6699ff',
                                 textColor: '#ffffff',
                                 fontStyle: AR.CONST.FONT_STYLE.BOLD
                                 }
                                 });
    
    
    var htmlWidgetmild = new AR.HtmlDrawable({
                                            uri: "assets/mild.html"
                                            }, 1.0, {
                                            viewportWidth: 320,
                                            viewportHeight: 300,
                                            backgroundColor: "#FFFFFF",
                                            translate: { x: 0.36, y: 0.5 },
                                            horizontalAnchor: AR.CONST.HORIZONTAL_ANCHOR.RIGHT,
                                            verticalAnchor: AR.CONST.VERTICAL_ANCHOR.TOP,
                                            opacity : 0.7
                                            });
    var soundmild = new AR.Sound("assets/mildrash.mp3", {
                             onLoaded : function(){soundmild.play();},
                             onError : function(){
                             // alert the user that the sound file could not be loaded
                             },
                             });
    /*
     The AR.ImageTrackable for the second page uses the same tracker but with a different target name and the second overlay.
     */
    var pageTwo = new AR.ImageTrackable(this.tracker, "mild", {
                                        drawables: {
                                        cam:htmlWidgetmild
                                        },
                                        onEnterFieldOfVision: function onEnterFieldOfVisionFn() {
                                        soundmild.load();
                                        },
                                        onImageRecognized: this.removeLoadingBar,
                                        onError: function(errorMessage) {
                                        alert(errorMessage);
                                        }
                                        });
},
    
removeLoadingBar: function() {
    if (!World.loaded) {
        var e = document.getElementById('loadingMessage');
        e.parentElement.removeChild(e);
        World.loaded = true;
    }
},
    
worldLoaded: function worldLoadedFn() {
   
}
};

World.init();
