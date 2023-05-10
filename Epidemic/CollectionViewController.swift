//
//  ViewController.swift
//  Epidemic
//
//  Created by Евгения Шарамет on 07.05.2023.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collection = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private static let identifier = "CollectionView"
    private let healthyPeople = UILabel()
    private let sickPeople = UILabel()
    private let finishLabel = UILabel()
    
    private let infectModel: InfectHumansModel
    private let simulationQueue = DispatchQueue(label: "simulation_queue")
    private let service: EpidemicService
    private let generator = UINotificationFeedbackGenerator()
    
    init(service: EpidemicService, infectModel: InfectHumansModel) {
        self.service = service
        self.infectModel = infectModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemIndigo
        setupCollectionView()
        simulation()
    }
    
    func setupCollectionView() {
        //MARK: - Healthy and sick Labels
        
        let hStackView = UIStackView()
        self.view.addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.distribution = .fillEqually
        hStackView.spacing = 10
        
        hStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        hStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        hStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        hStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        hStackView.addArrangedSubview(healthyPeople)
        healthyPeople.backgroundColor = .systemMint
        healthyPeople.layer.masksToBounds = true
        healthyPeople.layer.cornerRadius = 10
        healthyPeople.text = "🙂: \(infectModel.healthy)"
        
        hStackView.addArrangedSubview(sickPeople)
        sickPeople.backgroundColor = .systemMint
        sickPeople.layer.masksToBounds = true
        sickPeople.layer.cornerRadius = 10
        sickPeople.text = "🤢: \(infectModel.infected)"
        
        self.view.addSubview(collection)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: hStackView.bottomAnchor, constant: 10).isActive = true
        collection.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        collection.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        collection.isUserInteractionEnabled = true
        collection.delegate = self
        collection.dataSource = self
        collection.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionViewController.identifier)
        
        collection.backgroundColor = .systemIndigo
        
        self.view.addSubview(finishLabel)
        finishLabel.translatesAutoresizingMaskIntoConstraints = false
        finishLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        finishLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        finishLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        finishLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        finishLabel.layer.cornerRadius = 10
        finishLabel.backgroundColor = .systemMint
        finishLabel.layer.masksToBounds = true
        finishLabel.text = "Modulation finished"
        finishLabel.textAlignment = .center
        finishLabel.font = finishLabel.font.withSize(20)
        finishLabel.isHidden = true
    }
    
    func simulation() {
        if infectModel.healthy == 0 {
            finishLabel.isHidden = false
            return
        }
        let userInput = infectModel.extractSuddenlyInfected()
        simulationQueue.async {
            for point in userInput {
                self.service.update(position: point)
            }
            
            let result = self.service.next()
            let newResult = result.map { Point(x: $0.x - 1 , y: $0.y - 1) }
            
            DispatchQueue.main.async { [weak self] in
                self?.infectModel.updateAfterImitation(newPoints: newResult)
                self?.collection.reloadData()
                self?.healthyPeople.text = "🙂: \(self?.infectModel.healthy ?? 0)"
                self?.sickPeople.text = "🤢: \(self?.infectModel.infected ?? 0)"
                self?.simulation()
            }
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    //MARK: - internal functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidth(for: view.frame.width, spacing: 10)
        let height = width
        return CGSize(width: width, height: height )
    }
    
    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 6
        
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        return floor(finalWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collection.cellForItem(at: indexPath) as? CollectionCell
       else {
           return
       }
        generator.notificationOccurred(.warning)
        cell.configure(type: .sick)
        self.healthyPeople.text = "🙂: \(infectModel.healthy)"
        self.sickPeople.text = "🤢: \(infectModel.infected)"
        infectModel.updateModel(index: indexPath.row)
    }
}

extension CollectionViewController {
    //MARK: - internal functions

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.service.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewController.identifier, for: indexPath) as? CollectionCell
        else {
            return UICollectionViewCell()
        }
        let cellData = infectModel.getCellValue(index: indexPath.row)
        cell.configure(type: cellData)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }

    //MARK: - private functions
    
    private func updateCell(at indexPath: IndexPath, withData data: TypeOfPeople) {
        
         guard let cell = collection.cellForItem(at: indexPath) as? CollectionCell
        else {
            return
        }
        cell.configure(type: data)
    }
}

