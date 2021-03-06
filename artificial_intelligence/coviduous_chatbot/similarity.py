import re, math
from collections import Counter
from dataset.covid19_faqs.coronavirus_questions import COVID19_QUES
from dataset.personal_ques.personal_ques import PERSONAL_QUES
from dataset.tutorials.tutorials import TUTORIALS
from dataset.shortcuts.shortcuts import SHORTCUTS
from dataset.general_ques.general_ques import GENERAL


WORD = re.compile(r'\w+')


def get_cosine(vec1, vec2):
    intersection = set(vec1.keys()) & set(vec2.keys())
    numerator = sum([vec1[x] * vec2[x] for x in intersection])

    sum1 = sum([vec1[x] ** 2 for x in vec1.keys()])
    sum2 = sum([vec2[x] ** 2 for x in vec2.keys()])
    denominator = math.sqrt(sum1) * math.sqrt(sum2)

    if not denominator:
        return 0.0
    else:
        return float(numerator) / denominator


def text_to_vector(text):
    words = WORD.findall(text)
    return Counter(words)


def compare_similarity(word_one, word_two):
    vector1 = text_to_vector(word_one.lower())
    vector2 = text_to_vector(word_two.lower())

    return get_cosine(vector1, vector2)


def find_most_similar(word):
    max = {"answer": None, "score": 0, "question": None}

    for each in PERSONAL_QUES:
        score = compare_similarity(word, each['Question'])
        # strScore=str(score)
        # print("word is : " + word +"compared question : "+ each['Question'] + "score is : "+strScore)
        if score > max['score']:
            max['score'] = score
            max['answer'] = each['Answer']
            max['question'] = each['Question']
    for each in COVID19_QUES:
        score = compare_similarity(word, each['Question'])
        # strScore=str(score)
        # print("word is : " + word +"compared question : "+ each['Question'] + "score is : "+strScore)
        if score > max['score']:
            max['score'] = score
            max['answer'] = each['Answer']
            max['question'] = each['Question']
    for each in TUTORIALS:
        score = compare_similarity(word, each['Question'])
        # strScore=str(score)
        # print("word is : " + word +"compared question : "+ each['Question'] + "score is : "+strScore)
        if score > max['score']:
            max['score'] = score
            max['answer'] = each['Answer']
            max['question'] = each['Question']
    for each in SHORTCUTS:
        score = compare_similarity(word, each['Question'])
        # strScore=str(score)
        # print("word is : " + word +"compared question : "+ each['Question'] + "score is : "+strScore)
        if score > max['score']:
            max['score'] = score
            max['answer'] = each['Answer']
            max['question'] = each['Question']
    for each in GENERAL:
        score = compare_similarity(word, each['Question'])
        # strScore=str(score)
        # print("word is : " + word +"compared question : "+ each['Question'] + "score is : "+strScore)
        if score > max['score']:
            max['score'] = score
            max['answer'] = each['Answer']
            max['question'] = each['Question']
    print({"score": max['score'], "answer": max['answer'], "question": max['question']})
    return {"score": max['score'], "answer": max['answer'], "question": max['question']}
