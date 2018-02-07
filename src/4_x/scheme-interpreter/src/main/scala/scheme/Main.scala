package scheme

import scheme.parser.{Node, Parser}

object Main extends App {
  val code =
    """
      (define hoge "hoge")
    """.stripMargin

  val parser = new Parser(code)
  val node: Node = parser.parse(0).nodes(2)
  val generator = new Generator
  println(generator.generate(node).eval)
}



