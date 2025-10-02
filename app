"use client"

import { useState, useEffect } from 'react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { Badge } from '@/components/ui/badge'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { BookOpen, Brain, Trophy, Star, Volume2, CheckCircle, XCircle, RotateCcw } from 'lucide-react'

// Dados de vocabulário por nível
const vocabularyData = {
  beginner: [
    { word: "Hello", translation: "Olá", pronunciation: "/həˈloʊ/", example: "Hello, how are you?" },
    { word: "Thank you", translation: "Obrigado", pronunciation: "/θæŋk juː/", example: "Thank you for your help." },
    { word: "Water", translation: "Água", pronunciation: "/ˈwɔːtər/", example: "I drink water every day." },
    { word: "Food", translation: "Comida", pronunciation: "/fuːd/", example: "This food is delicious." },
    { word: "House", translation: "Casa", pronunciation: "/haʊs/", example: "My house is big." }
  ],
  intermediate: [
    { word: "Beautiful", translation: "Bonito/Linda", pronunciation: "/ˈbjuːtɪfəl/", example: "The sunset is beautiful." },
    { word: "Important", translation: "Importante", pronunciation: "/ɪmˈpɔːrtənt/", example: "Education is important." },
    { word: "Understand", translation: "Entender", pronunciation: "/ˌʌndərˈstænd/", example: "I understand the lesson." },
    { word: "Different", translation: "Diferente", pronunciation: "/ˈdɪfərənt/", example: "We have different opinions." },
    { word: "Experience", translation: "Experiência", pronunciation: "/ɪkˈspɪriəns/", example: "I have work experience." }
  ],
  advanced: [
    { word: "Sophisticated", translation: "Sofisticado", pronunciation: "/səˈfɪstɪkeɪtɪd/", example: "She has sophisticated taste." },
    { word: "Entrepreneur", translation: "Empreendedor", pronunciation: "/ˌɑːntrəprəˈnɜːr/", example: "He is a successful entrepreneur." },
    { word: "Phenomenon", translation: "Fenômeno", pronunciation: "/fəˈnɑːmɪnən/", example: "This is a rare phenomenon." },
    { word: "Magnificent", translation: "Magnífico", pronunciation: "/mæɡˈnɪfɪsənt/", example: "The view is magnificent." },
    { word: "Perseverance", translation: "Perseverança", pronunciation: "/ˌpɜːrsəˈvɪrəns/", example: "Success requires perseverance." }
  ]
}

// Quiz questions
const quizQuestions = [
  {
    question: "What does 'Beautiful' mean in Portuguese?",
    options: ["Bonito/Linda", "Feio", "Grande", "Pequeno"],
    correct: 0,
    level: "intermediate"
  },
  {
    question: "How do you say 'Obrigado' in English?",
    options: ["Hello", "Thank you", "Goodbye", "Please"],
    correct: 1,
    level: "beginner"
  },
  {
    question: "What's the pronunciation of 'Water'?",
    options: ["/ˈweɪtər/", "/ˈwɔːtər/", "/ˈwætər/", "/ˈwaɪtər/"],
    correct: 1,
    level: "beginner"
  },
  {
    question: "Complete: 'I have work ___'",
    options: ["experiment", "experience", "expensive", "explain"],
    correct: 1,
    level: "intermediate"
  }
]

export default function EnglishLearningApp() {
  const [currentLevel, setCurrentLevel] = useState('beginner')
  const [currentWordIndex, setCurrentWordIndex] = useState(0)
  const [showTranslation, setShowTranslation] = useState(false)
  const [progress, setProgress] = useState(0)
  const [streak, setStreak] = useState(0)
  const [totalWords, setTotalWords] = useState(0)
  
  // Quiz state
  const [currentQuiz, setCurrentQuiz] = useState(0)
  const [selectedAnswer, setSelectedAnswer] = useState(null)
  const [showQuizResult, setShowQuizResult] = useState(false)
  const [quizScore, setQuizScore] = useState(0)
  const [quizCompleted, setQuizCompleted] = useState(false)

  const currentVocabulary = vocabularyData[currentLevel]
  const currentWord = currentVocabulary[currentWordIndex]

  useEffect(() => {
    const saved = localStorage.getItem('englishProgress')
    if (saved) {
      const data = JSON.parse(saved)
      setProgress(data.progress || 0)
      setStreak(data.streak || 0)
      setTotalWords(data.totalWords || 0)
    }
  }, [])

  const saveProgress = (newProgress, newStreak, newTotal) => {
    const data = { progress: newProgress, streak: newStreak, totalWords: newTotal }
    localStorage.setItem('englishProgress', JSON.stringify(data))
  }

  const nextWord = () => {
    setShowTranslation(false)
    if (currentWordIndex < currentVocabulary.length - 1) {
      setCurrentWordIndex(currentWordIndex + 1)
    } else {
      setCurrentWordIndex(0)
    }
    
    const newProgress = Math.min(progress + 2, 100)
    const newStreak = streak + 1
    const newTotal = totalWords + 1
    
    setProgress(newProgress)
    setStreak(newStreak)
    setTotalWords(newTotal)
    saveProgress(newProgress, newStreak, newTotal)
  }

  const handleQuizAnswer = (answerIndex) => {
    setSelectedAnswer(answerIndex)
    setShowQuizResult(true)
    
    if (answerIndex === quizQuestions[currentQuiz].correct) {
      setQuizScore(quizScore + 1)
    }
    
    setTimeout(() => {
      if (currentQuiz < quizQuestions.length - 1) {
        setCurrentQuiz(currentQuiz + 1)
        setSelectedAnswer(null)
        setShowQuizResult(false)
      } else {
        setQuizCompleted(true)
      }
    }, 1500)
  }

  const resetQuiz = () => {
    setCurrentQuiz(0)
    setSelectedAnswer(null)
    setShowQuizResult(false)
    setQuizScore(0)
    setQuizCompleted(false)
  }

  const speakWord = (text) => {
    if ('speechSynthesis' in window) {
      const utterance = new SpeechSynthesisUtterance(text)
      utterance.lang = 'en-US'
      utterance.rate = 0.8
      speechSynthesis.speak(utterance)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-4">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="flex items-center justify-center gap-3 mb-4">
            <div className="p-3 bg-gradient-to-r from-blue-500 to-purple-600 rounded-2xl">
              <BookOpen className="w-8 h-8 text-white" />
            </div>
            <h1 className="text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              English Master
            </h1>
          </div>
          <p className="text-gray-600 text-lg">Aprenda inglês de forma interativa e divertida</p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          <Card className="bg-white/70 backdrop-blur-sm border-0 shadow-lg">
            <CardContent className="p-6 text-center">
              <div className="flex items-center justify-center gap-2 mb-2">
                <Trophy className="w-5 h-5 text-yellow-500" />
                <span className="font-semibold text-gray-700">Progresso</span>
              </div>
              <div className="text-2xl font-bold text-gray-800 mb-2">{progress}%</div>
              <Progress value={progress} className="h-2" />
            </CardContent>
          </Card>

          <Card className="bg-white/70 backdrop-blur-sm border-0 shadow-lg">
            <CardContent className="p-6 text-center">
              <div className="flex items-center justify-center gap-2 mb-2">
                <Star className="w-5 h-5 text-orange-500" />
                <span className="font-semibold text-gray-700">Sequência</span>
              </div>
              <div className="text-2xl font-bold text-gray-800">{streak}</div>
              <p className="text-sm text-gray-600">palavras seguidas</p>
            </CardContent>
          </Card>

          <Card className="bg-white/70 backdrop-blur-sm border-0 shadow-lg">
            <CardContent className="p-6 text-center">
              <div className="flex items-center justify-center gap-2 mb-2">
                <Brain className="w-5 h-5 text-green-500" />
                <span className="font-semibold text-gray-700">Total</span>
              </div>
              <div className="text-2xl font-bold text-gray-800">{totalWords}</div>
              <p className="text-sm text-gray-600">palavras aprendidas</p>
            </CardContent>
          </Card>
        </div>

        {/* Main Content */}
        <Tabs defaultValue="vocabulary" className="w-full">
          <TabsList className="grid w-full grid-cols-2 mb-8 bg-white/70 backdrop-blur-sm">
            <TabsTrigger value="vocabulary" className="data-[state=active]:bg-gradient-to-r data-[state=active]:from-blue-500 data-[state=active]:to-purple-600 data-[state=active]:text-white">
              Vocabulário
            </TabsTrigger>
            <TabsTrigger value="quiz" className="data-[state=active]:bg-gradient-to-r data-[state=active]:from-blue-500 data-[state=active]:to-purple-600 data-[state=active]:text-white">
              Quiz
            </TabsTrigger>
          </TabsList>

          {/* Vocabulary Tab */}
          <TabsContent value="vocabulary">
            <div className="space-y-6">
              {/* Level Selector */}
              <div className="flex flex-wrap gap-2 justify-center">
                {Object.keys(vocabularyData).map((level) => (
                  <Button
                    key={level}
                    variant={currentLevel === level ? "default" : "outline"}
                    onClick={() => {
                      setCurrentLevel(level)
                      setCurrentWordIndex(0)
                      setShowTranslation(false)
                    }}
                    className={currentLevel === level ? 
                      "bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700" : 
                      "hover:bg-blue-50"
                    }
                  >
                    {level.charAt(0).toUpperCase() + level.slice(1)}
                  </Button>
                ))}
              </div>

              {/* Word Card */}
              <Card className="bg-white/80 backdrop-blur-sm border-0 shadow-xl max-w-2xl mx-auto">
                <CardHeader className="text-center pb-4">
                  <div className="flex items-center justify-center gap-2 mb-2">
                    <Badge variant="secondary" className="bg-blue-100 text-blue-700">
                      {currentLevel.charAt(0).toUpperCase() + currentLevel.slice(1)}
                    </Badge>
                    <Badge variant="outline">
                      {currentWordIndex + 1} / {currentVocabulary.length}
                    </Badge>
                  </div>
                </CardHeader>
                
                <CardContent className="text-center space-y-6 pb-8">
                  <div className="space-y-4">
                    <div className="flex items-center justify-center gap-4">
                      <h2 className="text-4xl font-bold text-gray-800">
                        {currentWord.word}
                      </h2>
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => speakWord(currentWord.word)}
                        className="hover:bg-blue-50"
                      >
                        <Volume2 className="w-4 h-4" />
                      </Button>
                    </div>
                    
                    <p className="text-lg text-gray-600 font-mono">
                      {currentWord.pronunciation}
                    </p>
                  </div>

                  {showTranslation && (
                    <div className="space-y-4 animate-in fade-in duration-500">
                      <div className="p-4 bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl border border-green-200">
                        <p className="text-2xl font-semibold text-green-700 mb-2">
                          {currentWord.translation}
                        </p>
                        <p className="text-gray-700 italic">
                          "{currentWord.example}"
                        </p>
                      </div>
                    </div>
                  )}

                  <div className="flex flex-col sm:flex-row gap-3 justify-center">
                    {!showTranslation ? (
                      <Button
                        onClick={() => setShowTranslation(true)}
                        className="bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white px-8 py-3"
                      >
                        Ver Tradução
                      </Button>
                    ) : (
                      <Button
                        onClick={nextWord}
                        className="bg-gradient-to-r from-green-500 to-emerald-600 hover:from-green-600 hover:to-emerald-700 text-white px-8 py-3"
                      >
                        Próxima Palavra
                      </Button>
                    )}
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          {/* Quiz Tab */}
          <TabsContent value="quiz">
            <Card className="bg-white/80 backdrop-blur-sm border-0 shadow-xl max-w-2xl mx-auto">
              <CardHeader className="text-center">
                <CardTitle className="text-2xl text-gray-800">Quiz de Inglês</CardTitle>
                <CardDescription>
                  Teste seus conhecimentos
                </CardDescription>
              </CardHeader>
              
              <CardContent className="space-y-6">
                {!quizCompleted ? (
                  <>
                    <div className="flex items-center justify-between mb-4">
                      <Badge variant="outline">
                        Pergunta {currentQuiz + 1} / {quizQuestions.length}
                      </Badge>
                      <Badge variant="secondary" className="bg-purple-100 text-purple-700">
                        {quizQuestions[currentQuiz].level}
                      </Badge>
                    </div>

                    <div className="space-y-4">
                      <h3 className="text-xl font-semibold text-gray-800">
                        {quizQuestions[currentQuiz].question}
                      </h3>
                      
                      <div className="grid gap-3">
                        {quizQuestions[currentQuiz].options.map((option, index) => (
                          <Button
                            key={index}
                            variant="outline"
                            onClick={() => handleQuizAnswer(index)}
                            disabled={showQuizResult}
                            className={`p-4 text-left justify-start h-auto ${
                              showQuizResult
                                ? index === quizQuestions[currentQuiz].correct
                                  ? 'bg-green-100 border-green-500 text-green-700'
                                  : index === selectedAnswer && index !== quizQuestions[currentQuiz].correct
                                  ? 'bg-red-100 border-red-500 text-red-700'
                                  : ''
                                : 'hover:bg-blue-50'
                            }`}
                          >
                            <div className="flex items-center gap-3">
                              {showQuizResult && (
                                <>
                                  {index === quizQuestions[currentQuiz].correct && (
                                    <CheckCircle className="w-5 h-5 text-green-600" />
                                  )}
                                  {index === selectedAnswer && index !== quizQuestions[currentQuiz].correct && (
                                    <XCircle className="w-5 h-5 text-red-600" />
                                  )}
                                </>
                              )}
                              <span>{option}</span>
                            </div>
                          </Button>
                        ))}
                      </div>
                    </div>
                  </>
                ) : (
                  <div className="text-center space-y-6">
                    <div className="p-6 bg-gradient-to-r from-blue-50 to-purple-50 rounded-xl">
                      <Trophy className="w-16 h-16 text-yellow-500 mx-auto mb-4" />
                      <h3 className="text-2xl font-bold text-gray-800 mb-2">
                        Quiz Concluído!
                      </h3>
                      <p className="text-lg text-gray-600 mb-4">
                        Você acertou {quizScore} de {quizQuestions.length} perguntas
                      </p>
                      <div className="text-3xl font-bold text-purple-600">
                        {Math.round((quizScore / quizQuestions.length) * 100)}%
                      </div>
                    </div>
                    
                    <Button
                      onClick={resetQuiz}
                      className="bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white px-8 py-3"
                    >
                      <RotateCcw className="w-4 h-4 mr-2" />
                      Refazer Quiz
                    </Button>
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>
    </div>
  )
}
