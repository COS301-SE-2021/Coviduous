from similarity import find_most_similar
class Bot:

    def __init__(self):
        self.event_stack = []
        self.settings = {
            "min_score": 0.1,
            "help_email": "capslock.cos301@gmail.com"
        }

    def allow_question(self,question):
        answer = find_most_similar(question)
        return self.answer_question(answer,question)

    def answer_question(self,answer,question):
        #if answer['score'] > self.settings['min_score']:
        if answer['score'] == 0:
            #print(answer['score'])
            googleQuery="+".join(question.split(" "))
            return "Woops! I'm having trouble finding the answer to your question. Please email "+ self.settings['help_email'] +" if I was not able to answer your question. For convenience, a google link has been generated: https://www.google.com/search?q="+ googleQuery
        else:
            return answer['answer']