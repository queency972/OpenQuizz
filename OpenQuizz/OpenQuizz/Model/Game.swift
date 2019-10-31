//
//  File.swift
//  Game
//
//  Created by Steve Bernard on 19/05/2019.
//  Copyright © 2019 Steve Bernard. All rights reserved.
//

import Foundation


class Game {
    
    var score = 0
    var questions: [Question] = []
    // Pour obtenir la question en cours, nous allons créer une propriété privée
    private var currentIndex =  0
    
    // Nous allons créer une propriété (cette fois publique) Cette propriété est une propriété calculée en lecture seule qui renvoit l'élément à la position currentIndex dans notre tableau de questions.
    
    var currentQuestion: Question {
        return questions[currentIndex]
    }
    
    // Nous allons remettre à zéro le score, mettre la partie dans l'état over et remettre la propriété currentIndex à zéro.
    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        
        
        QuestionManager.shared.get { (questions) in
            self.questions = questions
            self.state = .ongoing
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }
    }
    
    // Etat de la partie
    enum State {
        case ongoing, over
    }
    var state: State = .ongoing
    
    // créer une méthode answerCurrentQuestion. Cette méthode va prendre un paramètre : answer de type Bool avec pour étiquette with. Dans cette méthode, nous allons mettre à jour le score et passer à la question suivante.
    
    func answerCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
        }
        goToNextQuestion()
    }
    
    // Pour cela, comparez la propriété count du tableau de question avec la propriété currentIndex. Si on a atteint la dernière question, finissez la partie en faisant passer la propriété state à over. Sinon, passez à la question suivante en incrémentant la propriété currentIndex de 1.
    
    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }
    
    private func finishGame() {
        state = .over
    }
}


