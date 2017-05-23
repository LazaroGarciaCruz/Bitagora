//
//  RotateTransitionAnimator.swift
//  NavTransition
//
//  Created by cice on 27/3/17.
//  Copyright © 2017 355 Berry Street. All rights reserved.
//

import UIKit

//Vamos a crear nuestra transicion de ViewController customizada, para ello debe extender de:
//NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate

//Esta animacion tenemos dos ViewController, S1 y S2. S2 estara ocultado arriba y S1 sera el visible y la animacion consistira en bajar S2 de arriba a abajo

class RotateTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duracion = 3.0
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
        
        //Parametro: angulo * CGFloat.pi / 180 para convertirlo en radianes
        let rotateOut = CGAffineTransform(rotationAngle: -90 * CGFloat.pi / 180)

        toView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        fromView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        
        toView.layer.position = CGPoint(x: 0, y: 0)
        fromView.layer.position = CGPoint(x: 0, y: 0)
        
        toView.transform = rotateOut
        
        container.addSubview(toView)
        container.addSubview(fromView)
        
        //Creamos la animacion en si (usingSpringWithDamping le da aceleracion a la animacion)
        UIView.animate(withDuration: duracion, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            if self.isPresentada {
                fromView.transform = rotateOut
                fromView.alpha = 0
                toView.transform = CGAffineTransform.identity
                toView.alpha = 1
            } else {
                fromView.transform = rotateOut
                fromView.alpha = 1.0
                toView.transform = CGAffineTransform.identity
                toView.alpha = 1.0
            }
            
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
