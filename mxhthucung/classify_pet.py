import sys
import random

def classify(image_path):
    labels = ['dog', 'cat', 'rabbit', 'hamster']
    return random.choice(labels)

if __name__ == "__main__":
    image_path = sys.argv[1]
    result = classify(image_path)
    print(result)