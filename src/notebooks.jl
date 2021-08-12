const NOTEBOOKS = [("Introduction", "introduction.jl"),
                   ("Supervised Learning", "supervised_learning.jl"),
                   ("Generalized Linear Regression", "generalized_linear_regression.jl"),
                   ("Flexibility and Bias-Variance-Decomposition", "flexibility.jl"),
                   ("Model Assessment", "model_evaluation.jl"),
                   ("Regularization", "regularization.jl"),
#                    ("Gradient Descent", "gradient_descent.jl")
                  ]

function list_notebooks(file)
    sp = splitpath(file)
    path = joinpath(@__DIR__, "..", "notebooks")
    filename = split(sp[end], "#")[1]
    list = join(["1. " * (nb == filename ?
                            name * " (this notebook)" :
                            "[$name](open?path=" * joinpath(path, nb) * ")")
                 for (name, nb) in NOTEBOOKS], "\n")
Markdown.parse("""# Course Overview

               $list
               """)
end
