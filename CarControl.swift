import UIKit


class CarControl{

    //send wheel control parameters to server
    func controlWheels(direction:String,url:String)
    {
        let requestUrl = url + direction
      //  let request = NSMutableURLRequest(url: NSURL(string: requestUrl)! as URL)
        let request = NSMutableURLRequest(URL: NSURL(string: requestUrl)!)
      //  request.httpMethod = "GET"
        request.HTTPMethod = "GET"
      //  let getString = "direction=\(direction)"
        
    //    print(getString)
        
    //    request.httpBody = getString.data(using: String.Encoding.utf8)
        
        // Excute HTTP Request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
        })
        
        task.resume()
        
    }
    
    func MountControl(url:String)
    {
        let requestUrl = url
        //  let request = NSMutableURLRequest(url: NSURL(string: requestUrl)! as URL)
        let request = NSMutableURLRequest(URL: NSURL(string: requestUrl)!)
        //  request.httpMethod = "GET"
        request.HTTPMethod = "GET"
        //  let getString = "direction=\(direction)"
        
        //    print(getString)
        
        //    request.httpBody = getString.data(using: String.Encoding.utf8)
        
        // Excute HTTP Request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
        })
        
        task.resume()

    
    
    }
}
