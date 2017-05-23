//
//  SlideTransitionAnimator.swift
//  NavTransition
//
//  Created by cice on 24/3/17.
//  Copyright © 2017 355 Berry Street. All rights reserved.
//

import UIKit

//Vamos a crear nuestra transicion de ViewController customizada, para ello debe extender de:
//NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate

//Esta animacion tenemos dos ViewController, S1 y S2. S2 estara ocultado arriba y S1 sera el visible y la animacion consistira en bajar S2 de arriba a abajo

class SlideTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duracion = 1.5
    var isPresentada = true
    
    //Este metodo especifica el controlador desde cual va a partir la animacion (presented) y hasta cual se va llevar la animacion (presenting)
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    //Este metodo especifica cual es la animacion
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //Con esto especeficamos la vista desde la que vamos a partir
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        //Con esto especificamos la vista a la que vamos
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        //Con esto especificamos la vista contenedora que es la vista que el sistema 
        //crea por defecto para contener las vistas que nosotros definimos en el storyboard
        let container = transitionContext.containerView
        
        //Ahora comenzamos a definir la animacion
        
        //Definimos la transformacion inicial en el que la posicion X no se modifica y
        //la posicion y sera por encima del frame
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        //Definimos la posicion final
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        
        //Comprobamos si se ha mostrar o no, esto se usa para que 
        //la animacion vaya en direccion contraria dependiendo de la
        //vista en la que estemos
        if isPresentada {
            //Sacamos la vista a animar fuera de pantalla
            toView.transform = offScreenRight
        }
        
        //Añadimos ambas vistas al container
        container.addSubview(fromView)
        container.addSubview(toView)
        
        //Creamos la animacion en si (usingSpringWithDamping le da aceleracion a la animacion)
        UIView.animate(withDuration: duracion, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            if self.isPresentada {
                fromView.transform = offScreenLeft
            } else {
                fromView.transform = offScreenRight
            }
            
            fromView.alpha = 0.5
            toView.transform = CGAffineTransform.identity
            toView.alpha = 1.0
            
            }) { (completado) in
                self.isPresentada = !self.isPresentada
                transitionContext.completeTransition(true)
        }
        
    }
    
    //Este metodo especifica cual es la duraccion de la animacion
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duracion
    }
    
}
