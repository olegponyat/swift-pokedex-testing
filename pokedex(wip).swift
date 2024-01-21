import UIKit

struct Pokemon: Codable {
    let name: String
    let sprites: Sprites
}

struct Sprites: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var pokemons: [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        fetchPokemon(name: "pikachu")
        fetchPokemon(name: "charmander")
        fetchPokemon(name: "squirtle")
    }

    func fetchPokemon(name: String) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name.lowercased())") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching Pokemon: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                self.pokemons.append(pokemon)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding Pokemon data: \(error)")
            }
        }.resume()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        let pokemon = pokemons[indexPath.row]

        cell.textLabel?.text = pokemon.name
        cell.imageView?.imageFromURL(urlString: pokemon.sprites.frontDefault)

        return cell
    }

    // MARK: - UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text?.lowercased(), !searchTerm.isEmpty {
            clearPokemons()
            fetchPokemon(name: searchTerm)
            searchBar.resignFirstResponder()
        }
    }

    // MARK: - Helper methods

    func clearPokemons() {
        pokemons.removeAll()
        tableView.reloadData()
    }
}

extension UIImageView {
    func imageFromURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }

            guard let data = data else { return }

            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}