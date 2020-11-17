//
//  ViewController.swift
//  NewsToday
//
//  Created by Macbook Air 13 on 06.11.2020.
//
import SafariServices

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
   
// MARK: - Reference
    private var pullControl = UIRefreshControl()

    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var category : [String] = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
   var country = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
    var news = News()
    var selectedCountry = String() {
        didSet {
            self.news.country = self.selectedCountry
        }
    }
    var selectedCategory = String() {
        didSet {
            self.news.category = self.selectedCategory
        }
    }
    
    
    
 // MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
        
        refreshListData(nil)
        pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
                pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
                if #available(iOS 10.0, *) {
                    tableView.refreshControl = pullControl
                } else {
                    tableView.addSubview(pullControl)
                }
    }
    
    @objc private func refreshListData(_ sender: Any?) {
        news.getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.pullControl.endRefreshing()
                
            }
        }
    }
    
 // MARK: - IBAction
    
    @IBAction func filter(_ sender: UIButton) {
        picker = UIPickerView.init()
           picker.delegate = self
        picker.dataSource = self
           picker.backgroundColor = UIColor.white
           picker.setValue(UIColor.black, forKey: "textColor")
           picker.autoresizingMask = .flexibleWidth
           picker.contentMode = .center
           picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
           self.view.addSubview(picker)

           toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .black
           toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
           self.view.addSubview(toolBar)
        
    }
    @objc func onDoneButtonTapped() {
        refreshListData(nil)
        self.news.articleArray = news.articleArray
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource{
 
 //
    func showTutorial(_ which: Int, urlString url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = news.result else {
            return 0
        }
        return result.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticleTableViewCell
        let article = self.news.result?.articles[indexPath.row]
        
        cell.descriptionLabel.text = article?.description
        cell.titleLabel.text = article?.title
        cell.authorLabel.text = article?.author
        cell.publishedAtLabel.text = article?.publishedAt

        if let url = URL(string:article?.urlToImage ?? "https://www.google.com/url?sa=i&url=http%3A%2F%2Fs-str.ru%2Fproject%2Fooo-plastek%2F&psig=AOvVaw1dFSKcR-fZV7SsRMEZ6kOW&ust=1604874192099000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCKCnsbe88ewCFQAAAAAdAAAAABAJ"){
            if let data = try? Data(contentsOf: url){
                cell.articleImage.image = UIImage(data:data)
            }
        }
        cell.textLabel?.font = UIFont(name: "System Bold" , size: 22.0)
      
        return cell
    }
    
// Open url in Safari
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.news.result?.articles[indexPath.row]

        showTutorial(indexPath.row, urlString: article!.url)
    }
    
}

// MARK: -UIPickerViewDataSource, UIPickerViewDelegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return category.count
        } else {
            return country.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return category[row]
        } else {
            return country[row]
        }
       
    }
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            self.selectedCategory = category[row]
            print(selectedCategory)
        } else {
            self.selectedCountry = country[row]
            print(selectedCountry)
        }
    }
}
