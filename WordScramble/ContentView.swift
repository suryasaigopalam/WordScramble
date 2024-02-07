//
//  ContentView.swift
//  WordScramble
//
//  Created by surya sai on 31/01/24.
//

import SwiftUI

struct ContentView: View {
    @State var usedWords:[String] = []
    @State var rootWord = ""
    @State var newWord = ""
    
    @State var errorTitle = ""
    @State var errorMessage = ""
    @State var showingError = false
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Eneter your word", text: $newWord)
                        .textInputAutocapitalization(.never )
                }
                .onSubmit {addNewWord()}
                
                Section {
                    ForEach(usedWords,id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            
                            Text(word)
                            
                        }
                    }
                }
                
            }
            .onAppear(perform: startGame)
            .navigationTitle(rootWord)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK"){}
                
            } message: {
                Text(errorMessage)
            }
        }
        
    }
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if answer.count == 0 {return}
        
        guard isOriginal(word: newWord) else{
            wordError(title: "word used already", message: "Be more original")
            return
        }
        guard isReal(word: newWord) else{
            wordError(title: "word Not reconginzed", message: "You can't just make them up, you know!")
            return
        }
        withAnimation(.easeInOut) {
            usedWords.insert(answer, at: 0)
        }
        newWord  = ""
        
    }
    func startGame() {
        if let url = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let wordString = try? String(contentsOf: url) {
                let words = wordString.components(separatedBy: "\n")
                rootWord = words.randomElement()!
            }
            
        }
        
    }
    func isOriginal(word:String)->Bool {
        !usedWords.contains(word)
    }
    func isPossible(word:String)->Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
             }else {
                return false;
            }
        }
        return true
    }
    func isReal(word:String)->Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    func wordError(title:String,message:String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
