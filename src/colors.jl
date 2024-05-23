# colors.jl

global oi = wc = Makie.wong_colors(); # Okabe-Ito colors
global berlin = colorschemes[:berlin];

export wc, oi, berlin

# https://yaleidentity.yale.edu/guidelines/websites#:~:text=The%20standard%20colors%20for%20the,the%20page%20design%20requires%20it.
global yale = (
    blues = [
        parse(Colorant, "#00356b"),
        parse(Colorant, "#286dc0"),
        parse(Colorant, "#63aaff"),
    ],
    grays = [
        parse(Colorant, "#222222"),
        parse(Colorant, "#4a4a4a"),
        parse(Colorant, "#978d85"),
        parse(Colorant, "#dddddd"),
        parse(Colorant, "#f9f9f9")
    ],
    accent = [
        parse(Colorant, "#5f712d"),
        parse(Colorant, "#bd5319"),
    ],
);

export yale

# https://www.umass.edu/university-relations/brand/brand-elements
global umass = (
    brand = [parse(Colorant, "#881c1c"), parse(Colorant, "#212721")],
    secondary = [
        parse(Colorant, "#ffc72c"), parse(Colorant, "#ff9e1b"),
        parse(Colorant, "#615e9b"), parse(Colorant, "#44693d"),
        parse(Colorant, "#5e4b3c"), parse(Colorant, "#002554")
    ],
    neutrals = [
        parse(Colorant, "#373a36"), parse(Colorant, "#505759"),
        parse(Colorant, "#a2aaad")
    ],
);

export umass

# https://visualidentity.columbia.edu/branding#:~:text=To%20remain%20compliant%20with%20WCAG,components%20and%20large%20text%20only.
global columbia = (
    blue = [parse(Colorant, "#b9d9eb"), parse(Colorant, "#1d4f91")],
    # secondary = [
    #     parse(Colorant, "#ffc72c"), parse(Colorant, "#ff9e1b"),
    #     parse(Colorant, "#615e9b"), parse(Colorant, "#44693d"),
    #     parse(Colorant, "#5e4b3c"), parse(Colorant, "#002554")
    # ],
    # neutrals = [
    #     parse(Colorant, "#373a36"), parse(Colorant, "#505759"),
    #     parse(Colorant, "#a2aaad")
    # ]
);

export columbia
