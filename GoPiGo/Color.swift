import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    //from stackoverflow
    //get rgb code from UIColor 
        func rgb() -> (red:Double, green:Double, blue:Double, alpha:Double)? {
            var fRed : CGFloat = 0
            var fGreen : CGFloat = 0
            var fBlue : CGFloat = 0
            var fAlpha: CGFloat = 0
            if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
                let iRed = Double(fRed * 255.0)
                let iGreen = Double(fGreen * 255.0)
                let iBlue = Double(fBlue * 255.0)
                let iAlpha = Double(fAlpha * 255.0)
                
                return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
            } else {
                // Could not extract RGBA components:
                return nil
            }
        }
    
   
    
}



//extension UIView {
//    func layerGradient() {
//        let layer : CAGradientLayer = CAGradientLayer()
//        layer.frame.size = self.frame.size
//        layer.frame.origin = CGPoint(x:0.0,y:0.0)
//        layer.cornerRadius = CGFloat(frame.width / 20)
//        
//        let color0 = UIColor(red:250.0/255, green:250.0/255, blue:250.0/255, alpha:0.5).cgColor
//        let color1 = UIColor(red:200.0/255, green:200.0/255, blue: 200.0/255, alpha:0.1).cgColor
//        let color2 = UIColor(red:150.0/255, green:150.0/255, blue: 150.0/255, alpha:0.1).cgColor
//        let color3 = UIColor(red:100.0/255, green:100.0/255, blue: 100.0/255, alpha:0.1).cgColor
//        let color4 = UIColor(red:50.0/255, green:50.0/255, blue:50.0/255, alpha:0.1).cgColor
//        let color5 = UIColor(red:0.0/255, green:0.0/255, blue:0.0/255, alpha:0.1).cgColor
//        let color6 = UIColor(red:150.0/255, green:150.0/255, blue:150.0/255, alpha:0.1).cgColor
//        
//        layer.colors = [color0,color1,color2,color3,color4,color5,color6]
//        self.layer.insertSublayer(layer, at: 0)
//    }
//}
