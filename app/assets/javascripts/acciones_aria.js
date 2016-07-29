var AriaInit = function() {
    


    
   // $('li.items-submenu').prepend('<span class="iconosubmenu"></span>');
    $('.level0  li:has(ul)').addClass('li_submenu');
    $('.li_submenu > a').after('<span class="iconosubmenu"> <span class="icono"></span></span>');

    
    //Menu TOP
    $('.menu-top .icon').click(function(){
        $('.menu-top').toggleClass('active');
        $('ul.topmenu').slideToggle(300);
    });
    
    //Buscador TOP
    $('span.borrar').click(function(){
        $('#buscar').val('');
    });
    
    //Mini Cart
    $('header .navegacion .carrito').click(function(){
        $('.header-cart').slideToggle(300);
        $('.menu-mobile').removeClass('activo');
    }); 
    
    $('.header-cart .cerrar').click(function(){
          $('.header-cart').slideUp(300);
    }); 
    
    
    //Mobile Menu
    $('.menu-mobile').click(function(){
        $(this).toggleClass('activo');
        $('.header-cart').slideUp(300);
        $('ul.level0').slideToggle(300);
        $('.level0 > .li_submenu').removeClass('active');
        $('.level1 > .li_submenu').removeClass('active');
        $('.li_submenu .level1').slideUp();
        $('.li_submenu .level2').slideUp();
    });
    
    // Buscar Mobile
    $('.buscar_mobile').click(function(){
        $(this).toggleClass('activo');
        $('.busca_form').slideToggle(300);
        $('.header-cart').slideUp(300);
        $('.menu-mobile').removeClass('activo');
        $('ul.level0').slideUp(300);
        $('.level0 > .li_submenu').removeClass('active');
        $('.level1 > .li_submenu').removeClass('active');
        $('.li_submenu .level1').slideUp();
        $('.li_submenu .level2').slideUp();
    });
    
    
    
    
    var nombreProducto = $('.product-view-page .product-name');
    
    var ocultarmenu = function() {
        if($('ul.level0').is(':visible')){
                $('ul.level0').slideUp(300);
            }
    };
    
    
    
// ------------------------------------------>
    
    (function($){
    // -> Cuando Carga <-
      $(document).ready(function(){
        var current_width = $(window).width();
        if(current_width < 970){
            
            nombreProducto.insertBefore('.product-view-page .product-imagen');

           $('.level0 > li').unbind('hover');
            
            //Mini Cart
            $('header .navegacion .carrito').bind( 'click', ocultarmenu ); 
            
        } if (current_width < 744) {
             nombreProducto.insertBefore('.product-view-page .product-imagen');
        }else if (current_width > 971) {
            
             //Mini Cart
            $('header .navegacion .carrito').unbind( 'click', ocultarmenu ); 

            $('.level0 > li').hover(function(){
                  $(this).children('.level1').slideDown(300);
            },function(){
                $(this).children('.level1').slideUp(300);
            }); 
            $('.level1 > li').hover(function(){
                  $(this).children('.level2').slideDown(300);
            },function(){
                $(this).children('.level2').slideUp(300);
            }); 
            
        }if (current_width > 745) {
             nombreProducto.insertBefore('.product-view-page .product-info .product-price');
        }
      });
        
      // -> Resize <-
     $(window).resize(function(){
        var current_width = $(window).width();
        if(current_width < 970){
            
            
            $('.level0 > li, .level1 > li, .level1, .level0').unbind();
            //Mini Cart
            $('header .navegacion .carrito').bind( 'click', ocultarmenu ); 
            
            
        }if (current_width < 744) {
             nombreProducto.insertBefore('.product-view-page .product-imagen');
        }else if (current_width > 971) {
            //Mini Cart
            $('header .navegacion .carrito').unbind( 'click', ocultarmenu ); 
            
            
            
            
            $('.level0').hide();
            $('.menu-mobile').removeClass('activo');
            
            $('.busca_form').hide();
            $('.buscar_mobile').removeClass('activo');


          //Hover al hacer Resize
            $('.level0 > li').hover(function(){
                  $(this).children('.level1').slideDown(300);
            },function(){
                $(this).children('.level1').slideUp(300);
            });   
            $('.level1 > li').hover(function(){
                  $(this).children('.level2').slideDown(300);
            },function(){
                $(this).children('.level2').slideUp(300);
            });   
            
            $('.level0 > .li_submenu').removeClass('active');
            $('.level1 > .li_submenu').removeClass('active');
            $('.li_submenu .level1').slideUp();
            $('.li_submenu .level2').slideUp();
                        
        }
         if (current_width > 745) {
             nombreProducto.insertBefore('.product-view-page .product-info .product-price');
        }
         if (current_width > 480) {
            $('.busca_form').hide();
            $('.buscar_mobile').removeClass('activo');
        }
      });
        
    })(jQuery);
    
// ------------------------------------------>
    

    // -> MENU MOBILE
    
    $('.level0 > .li_submenu > .iconosubmenu').click(function(){
        $('.li_submenu .level1').slideUp();
       var comprobar = $(this).next();
        $('.level0 > .li_submenu').removeClass('active');
        $('.level1 > .li_submenu').removeClass('active');
        $('.li_submenu .level2').slideUp();
        $(this).closest('li').addClass('active');
         if((comprobar.is('ul')) && (comprobar.is(':visible'))) {
            comprobar.slideUp('normal');
             $(this).closest('li').removeClass('active');
         }
         if((comprobar.is('ul')) && (!comprobar.is(':visible'))) {
            $('.li_submenu ul ul:visible').slideUp('normal');
            comprobar.slideDown('normal');
         }
   });

   $('.level1 > .li_submenu > .iconosubmenu').click(function(){
        $('.li_submenu .level2').slideUp();
       var comprobar = $(this).next();
        $('.level1 > .li_submenu').removeClass('active');
        $(this).closest('li').addClass('active');
         if((comprobar.is('ul')) && (comprobar.is(':visible'))) {
            comprobar.slideUp('normal');
             $(this).closest('li').removeClass('active');
         }
         if((comprobar.is('ul')) && (!comprobar.is(':visible'))) {
            $('.li_submenu ul ul:visible').slideUp('normal');
            comprobar.slideDown('normal');
         }
   });
    
    
    // -> Tabs Producto Descripccion
    $('.product-descripcion label').click(function(){
        $('.product-descripcion label').removeClass('active');
        $(this).addClass('active');
    });
    
    $('.product-descripcion label.tab1').click(function(){
        $('.product-descripcion .content-tab3, .product-descripcion .content-tab2').slideUp(300);
        if($('.product-descripcion .content-tab1').is(':visible')){

            }else{
                $('.product-descripcion .content-tab1').slideDown(300);
            }
    });
    
    $('.product-descripcion label.tab2').click(function(){
        $('.product-descripcion .content-tab1, .product-descripcion .content-tab3').slideUp(300);
        if($('.product-descripcion .content-tab2').is(':visible')){

            }else{
                $('.product-descripcion .content-tab2').slideDown(300);
            }
    });
    
    $('.product-descripcion label.tab3').click(function(){
        $('.product-descripcion .content-tab1, .product-descripcion .content-tab2').slideUp(300);
        if($('.product-descripcion .content-tab3').is(':visible')){

            }else{
                $('.product-descripcion .content-tab3').slideDown(300);
            }
    });
    
    // ->  Carrito Costos de Envío
    
    $('.resumen .label.envios span.link').click(function(){
        $('.resumen .label.envios ul.lista-envios').slideToggle(300);
    });
    
    
    
};