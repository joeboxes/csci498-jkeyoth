#!/usr/bin/python

import os
os.system("git diff Square/Main.xml testVersion/Square/Main.xml")
os.system("git diff Square/Square.xml testVersion/Square/Square.xml")
os.system("git diff Square/SquareGame.xml testVersion/Square/SquareGame.xml")

os.system("git diff ExpressionlessSquare/Main.xml testVersion/ExpressionlessSquare/Main.xml")
os.system("git diff ExpressionlessSquare/Square.xml testVersion/ExpressionlessSquare/Square.xml")
os.system("git diff ExpressionlessSquare/SquareGame.xml testVersion/ExpressionlessSquare/SquareGame.xml")

os.system("git diff ArrayTest/Main.xml testVersion/ArrayTest/Main.xml")
