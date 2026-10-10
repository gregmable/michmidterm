import SwiftUI

struct Question {
    let prompt: String
    let choices: [String]
    let correctIndex: Int
}

struct ContentView: View {
    private let questions: [Question] = [
        Question(prompt: "When are U.S. midterm general elections typically held?",
                 choices: ["Every November on the first Tuesday after the first Monday in even-numbered years between presidential elections", "Every July", "On the first Monday of December", "Every year in January"],
                 correctIndex: 0),
        Question(prompt: "Which federal body has all its seats up for election every two years?",
                 choices: ["U.S. Senate", "U.S. House of Representatives", "Supreme Court", "State legislatures only"],
                 correctIndex: 1),
        Question(prompt: "How long is a U.S. Senator's term?",
                 choices: ["2 years", "4 years", "6 years", "8 years"],
                 correctIndex: 2),
        Question(prompt: "Which statewide executive office in Michigan is commonly on the midterm ballot?",
                 choices: ["Governor", "Mayor of Detroit only", "President", "Supreme Court Justice only"],
                 correctIndex: 0),
        Question(prompt: "Where can Michigan voters find their polling location and ballot information?",
                 choices: ["Michigan Voter Information Center or your local clerk", "Only at the federal courthouse", "Only on social media", "At a retail store"],
                 correctIndex: 0),
        Question(prompt: "Which of the following are common ways to cast a ballot in Michigan?",
                 choices: ["In-person on Election Day", "Absentee/mail-in voting", "Early in-person voting (absentee in-person)", "All of the above"],
                 correctIndex: 3),
        Question(prompt: "What is a ballot proposal (also called a ballot question)?",
                 choices: ["A local or statewide question placed before voters to approve or reject a law or constitutional change", "A candidate's campaign slogan", "A type of voter ID", "A polling place"],
                 correctIndex: 0),
        Question(prompt: "Who typically administers elections at the county level in Michigan?",
                 choices: ["County clerk or local election officials", "The U.S. Congress", "State Supreme Court justices", "Private companies only"],
                 correctIndex: 0),
        Question(prompt: "Which of these is a way to register to vote in Michigan?",
                 choices: ["Online through the state portal", "By mail", "In person at your local clerk's office", "All of the above"],
                 correctIndex: 3),
        Question(prompt: "Why are midterm elections important?",
                 choices: ["They determine membership in Congress and can change the balance of power", "They only affect local school schedules", "They always select the President", "They are held every month"],
                 correctIndex: 0)
    ]

    @State private var currentIndex: Int = 0
    @State private var selectedAnswers: [Int?]
    @State private var showResults: Bool = false

    init() {
        _selectedAnswers = State(initialValue: Array(repeating: nil, count: questions.count))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                ProgressView(value: Double(currentIndex), total: Double(questions.count))

                Text("Question \(currentIndex + 1) of \(questions.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(questions[currentIndex].prompt)
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .padding(.top, 8)

                VStack(spacing: 10) {
                    ForEach(0..<questions[currentIndex].choices.count, id: \\.self) { choiceIndex in
                        let choice = questions[currentIndex].choices[choiceIndex]
                        Button(action: {
                            selectedAnswers[currentIndex] = choiceIndex
                        }) {
                            HStack {
                                Image(systemName: selectedAnswers[currentIndex] == choiceIndex ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedAnswers[currentIndex] == choiceIndex ? .accentColor : .secondary)
                                Text(choice)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(selectedAnswers[currentIndex] == choiceIndex ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 1))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                Spacer()

                HStack {
                    Button(action: previous) {
                        Label("Previous", systemImage: "chevron.left")
                    }
                    .disabled(currentIndex == 0)

                    Spacer()

                    if currentIndex < questions.count - 1 {
                        Button(action: next) {
                            Label("Next", systemImage: "chevron.right")
                        }
                        .disabled(selectedAnswers[currentIndex] == nil)
                    } else {
                        Button(action: finish) {
                            Text("Finish")
                                .bold()
                        }
                        .disabled(selectedAnswers[currentIndex] == nil)
                    }
                }
            }
            .padding()
            .navigationTitle("Michigan Midterm Quiz")
            .sheet(isPresented: $showResults) {
                ResultsView(questions: questions, selectedAnswers: selectedAnswers, onClose: { showResults = false; currentIndex = 0; selectedAnswers = Array(repeating: nil, count: questions.count) })
            }
        }
    }

    private func next() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        }
    }

    private func previous() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }

    private func finish() {
        showResults = true
    }
}

struct ResultsView: View {
    let questions: [Question]
    let selectedAnswers: [Int?]
    let onClose: () -> Void

    var score: Int {
        zip(questions, selectedAnswers).reduce(0) { partial, pair in
            let (q, sel) = pair
            return partial + ((sel == q.correctIndex) ? 1 : 0)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("Your score: \(score)/\(questions.count)")
                    .font(.title)
                    .bold()

                List {
                    ForEach(0..<questions.count, id: \\.self) { idx in
                        let q = questions[idx]
                        VStack(alignment: .leading, spacing: 6) {
                            Text(q.prompt)
                                .font(.subheadline)
                                .bold()
                            Text("Your answer: \(answerText(for: idx))")
                                .foregroundColor(isCorrect(idx) ? .green : .red)
                            if !isCorrect(idx) {
                                Text("Correct: \(q.choices[q.correctIndex])")
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }

                Button(action: onClose) {
                    Text("Close & Reset")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Results")
        }
    }

    private func isCorrect(_ index: Int) -> Bool {
        guard let sel = selectedAnswers[index] else { return false }
        return sel == questions[index].correctIndex
    }

    private func answerText(for index: Int) -> String {
        if let sel = selectedAnswers[index] {
            return questions[index].choices[sel]
        } else {
            return "No answer"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
