//
//  TestView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/28/22.
//

import SwiftUI
import RichText

struct TestView: View {
    @State var  html = """
        <h1>Non quam nostram quidem, inquit Pomponius iocans;</h1>
        
        <img src = "https://user-images.githubusercontent.com/73557895/126889699-a735f993-2d95-4897-ae40-bcb932dc23cd.png">
        

        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quis istum dolorem timet? Sit sane ista voluptas. Quis est tam dissimile homini. Duo Reges: constructio interrete. <i>Quam illa ardentis amores excitaret sui! Cur tandem?</i> </p>

        <dl>
            <dt><dfn>Avaritiamne minuis?</dfn></dt>
            <dd>Placet igitur tibi, Cato, cum res sumpseris non concessas, ex illis efficere, quod velis?</dd>
            <dt><dfn>Immo videri fortasse.</dfn></dt>
            <dd>Quae qui non vident, nihil umquam magnum ac cognitione dignum amaverunt.</dd>
            <dt><dfn>Si longus, levis.</dfn></dt>
            <dd>Ita ne hoc quidem modo paria peccata sunt.</dd>
        </dl>


        <ol>
            <li>Possumusne ergo in vita summum bonum dicere, cum id ne in cena quidem posse videamur?</li>
            <li>Placet igitur tibi, Cato, cum res sumpseris non concessas, ex illis efficere, quod velis?</li>
            <li>Unum nescio, quo modo possit, si luxuriosus sit, finitas cupiditates habere.</li>
        </ol>


        <blockquote cite="http://loripsum.net">
            Aristoteles, Xenocrates, tota illa familia non dabit, quippe qui valitudinem, vires, divitias, gloriam, multa alia bona esse dicant, laudabilia non dicant.
        </blockquote>


        <p>Scrupulum, inquam, abeunti; Conferam tecum, quam cuique verso rem subicias; Audeo dicere, inquit. Maximus dolor, inquit, brevis est. Nos commodius agimus. </p>

        <ul>
            <li>Cur igitur, inquam, res tam dissimiles eodem nomine appellas?</li>
            <li>Omnia peccata paria dicitis.</li>
        </ul>


        <h2>Laboro autem non sine causa;</h2>

        <p>Itaque contra est, ac dicitis; <code>Illa argumenta propria videamus, cur omnia sint paria peccata.</code> </p>

        <pre>Nunc dicam de voluptate, nihil scilicet novi, ea tamen, quae
        te ipsum probaturum esse confidam.

        Sin est etiam corpus, ista explanatio naturae nempe hoc
        effecerit, ut ea, quae ante explanationem tenebamus,
        relinquamus.
        </pre>



        """
    
    var body: some View {
        ScrollView{
            RichText(html: html)
                .lineHeight(170)
                .imageRadius(12)
                .fontType(.system)
                .colorScheme(.automatic)
                .colorImportant(true)
                .linkOpenType(.SFSafariView)
                .linkColor(ColorSet(light: "#007AFF", dark: "#0A84FF"))
                .placeholder {
                    Text("loading")
                }
        }
    }
    
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
