//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Steve Bernard on 10/05/2019.
//  Copyright © 2019 Steve Bernard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!

    var game = Game()

    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)

        startNewGame()

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        questionView.title = game.currentQuestion.title

    }

    @IBAction func didTapNewGameButton() {
        startNewGame()
    }

    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameButton.isHidden = true

        questionView.title = "Loading..."
        questionView.style = .standard

        scoreLabel.text = "0 / 10"
        scoreLabel.textColor = UIColor.red
        game.refresh()
    }

    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default: break

            }
        }
    }

    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)

        let screenWidth = UIScreen.main.bounds.width
        let translationPercent = translation.x / (screenWidth/2)
        let rotationAngle = (CGFloat.pi / 6) * translationPercent

        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)

        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform

        if translation.x > 0 {
            questionView.style = .correct
        }
        else {
            questionView.style = .incorrect
        }

    }

    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }
        // Modification de la coleur du text suivant le score.
        scoreLabel.text = "\(game.score) / 10"
        if game.score > 5 {
            scoreLabel.textColor = UIColor.orange
        }
        else if game.score > 8 {
            scoreLabel.textColor = UIColor.green
        }

        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        }
        else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)

        }

        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }) { (success) in
            if success  {
                self.showQuestionView()
            }
        }
    }

    private func showQuestionView() {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        questionView.style = .standard
        questionView.title = game.currentQuestion.title

        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
            gameOver()
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
        }, completion: nil)

    }

    // Add this function to animate quiestionView when the game is Over.
    private func gameOver() {
        if game.score < 5 {
            questionView.title = "😱 Try again !"
            questionView.backgroundColor = UIColor.red
        }
        else if game.score >= 5 {
            questionView.title = "😏 You can do better !"
            questionView.backgroundColor = UIColor.orange
        }
        else if game.score >= 8 {
            questionView.title = "Well done 👏🏽👏🏽👏🏽 !"
            questionView.backgroundColor = UIColor.green
        }

    }

}

