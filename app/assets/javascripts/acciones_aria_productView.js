$(document).ready(function(){

// ------------------------------------------>
     (function($){
      // -> Resize <-
     $(window).resize(function(){
        var current_width = $(window).width();
        if(current_width < 970){
              // PAGINA DEL PRODUCTO
            $('.zoomContainer').remove();
            $("#img_01").elevateZoom({

                constrainSize: '100%',
                zoomType: "lens",
                borderSize: 2,
                borderColour: '#8dc63f',
                containLensZoom: true,
                gallery:'galeria-thumbs',
                cursor: 'pointer',
                lensShape : "round",
                lensFadeIn: 400,
                lensFadeOut:200,
                galleryActiveClass: "active"
            });
  
        }else if (current_width > 971) {

            
            // PAGINA DEL PRODUCTO
            $('.zoomContainer').remove();
            $("#img_01").elevateZoom({

                constrainSize: '100%',
                zoomType: "lens",
                borderSize: 2,
                borderColour: '#8dc63f',
                containLensZoom: true,
                gallery:'galeria-thumbs',
                cursor: 'pointer',
                lensShape : "round",
                lensFadeIn: 400,
                lensFadeOut:200,
                galleryActiveClass: "active"
            });

            
        }
      });
        
    })(jQuery);
    
// ------------------------------------------>


// PAGINA DEL PRODUCTO
        $("#img_01").elevateZoom({

            constrainSize: '100%',
            zoomType: "lens",
            borderSize: 2,
            borderColour: '#8dc63f',
            containLensZoom: true,
            gallery:'galeria-thumbs',
            cursor: 'pointer',
            lensShape : "round",
            lensFadeIn: 400,
            lensFadeOut:200,
            galleryActiveClass: "active"
        });

  
    
    
    
    
    
});