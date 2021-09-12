from coviduous_bot import Bot

from flask import Flask,jsonify,render_template, request
chatbot= Bot()
app = Flask(__name__)
app.static_folder = 'static'

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/get")
def get_bot_response():
    userText = request.args.get('msg')
    return str(chatbot.allow_question(userText))

@app.route('/api/message', methods=['POST'])
def prognosis():
    data = request.get_json()
    message = data.get('question', '')
    tutorial = "tutorial"
    shortcut="shortcut"
    if message != None and tutorial in message:
        reply = str(chatbot.allow_question(message))
        responseData={
        "recieved_message":message,
        "is_tutorial":"true",
        "is_shortcut":"false",
        "is_normal_question":"false",
        "answer":reply
        }
        return jsonify(responseData)
    elif message != None and shortcut in message:
        reply = str(chatbot.allow_question(message))
        responseData={
        "recieved_message":message,
        "is_tutorial":"false",
        "is_shortcut":"true",
        "is_normal_question":"false",
        "answer":reply
        }
        return jsonify(responseData)
    else:
        reply = str(chatbot.allow_question(message))
        responseData={
        "recieved_message":message,
        "is_tutorial":"false",
        "is_shortcut":"false",
        "is_normal_question":"true",
        "answer":reply
        }
        return jsonify(responseData)
    
if __name__ == "__main__":
    app.run()


