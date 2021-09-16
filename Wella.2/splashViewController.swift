import UIKit



class splashViewController: ExecuteApi {
    @IBOutlet weak var splash: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        splash.image = UIImage.gif(asset: "wella1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.push(vcId: "LOGINNC", vc: self)
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
             super.viewWillTransition(to: size, with: coordinator)
             let value = UIInterfaceOrientation.portrait.rawValue
             UIDevice.current.setValue(value, forKey: "orientation")
         }
}








