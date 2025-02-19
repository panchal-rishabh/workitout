import UIKit

// Model to store workout suggestions from AI
struct WorkoutSuggestion: Decodable {
    var suggestions: String
}

class WorkoutViewController: UIViewController {
    
    let bodyAreas = ["Shoulders", "Triceps", "Biceps", "Chest", "Back", "Abs"]
    
    var bodyAreaTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyAreaTableView = UITableView(frame: self.view.frame, style: .plain)
        bodyAreaTableView.delegate = self
        bodyAreaTableView.dataSource = self
        self.view.addSubview(bodyAreaTableView)
    }
    
    // Function to make API request to get AI-generated workouts
    func getWorkoutSuggestions(for bodyArea: String) {
        let url = URL(string: "http://YOUR_SERVER_URL/get_workout")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the body with the selected body area
        let requestBody: [String: Any] = ["body_area": bodyArea]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        // Make the network call to the backend
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            
            // Parse the response from the backend
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let workoutSuggestion = try decoder.decode(WorkoutSuggestion.self, from: data)
                    DispatchQueue.main.async {
                        self.showWorkoutSuggestions(workoutSuggestion.suggestions)
                    }
                } catch {
                    print("Error parsing response:", error)
                }
            }
        }
        task.resume()
    }
    
    // Show workout suggestions in an alert
    func showWorkoutSuggestions(_ suggestions: String) {
        let alertController = UIAlertController(title: "Workout Suggestions", message: suggestions, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bodyAreas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = bodyAreas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bodyArea = bodyAreas[indexPath.row]
        getWorkoutSuggestions(for: bodyArea)
    }
}
