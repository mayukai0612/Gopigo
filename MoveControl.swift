import UIKit


class MoveControl{

    //send wheel control parameters to server
    func controlWheels(direction:String,url:String)
    {
        let requestUrl = url + direction
        let request = NSMutableURLRequest(url: NSURL(string: requestUrl)! as URL)
        request.httpMethod = "GET"
    
      //  let getString = "direction=\(direction)"
        
    //    print(getString)
        
    //    request.httpBody = getString.data(using: String.Encoding.utf8)
        
        // Excute HTTP Request
       let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            
        })
        
        task.resume()
        
    }
}
