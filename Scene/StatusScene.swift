// ステータス表示
import SpriteKit
class StatusScene: BaseScene {
    var _cost : Int = 0
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red:0.1,green:0.0,blue:0.1,alpha:1.0)
        setMoney()
        setHeader()
        
        _cost = CommonData.getDataByInt("lv") * 10
        
        var lvLabel : SKLabelNode = SKLabelNode(fontNamed: CommonConst.font_regular)
        let lv : Int = CommonData.getData("lv") as! Int
        lvLabel.text = "LV : \(lv)"
        lvLabel.fontSize = CGFloat(CommonConst.font_size_normal)
        let y1 : CGFloat = CGRectGetMaxY(self.frame) - CGFloat(CommonConst.headerHeight + CommonConst.textBlankHeight)
        lvLabel.position = CGPointMake(CGRectGetMidX(self.frame), y1)
        self.addChild(lvLabel)

        let y2 = y1 - CGFloat(CommonConst.textBlankHeight)
        let y3 = y2 - CGFloat(CommonConst.textBlankHeight)
        let y4 = y3 - CGFloat(CommonConst.textBlankHeight)
        let y5 = y4 - CGFloat(CommonConst.textBlankHeight)
        let y6 = y5 - CGFloat(CommonConst.textBlankHeight)
        let y7 = y6 - CGFloat(CommonConst.textBlankHeight)
        let y8 = y7 - CGFloat(CommonConst.textBlankHeight)
        let y9 = y8 - CGFloat(CommonConst.textBlankHeight)
        let y10 = y9 -  CGFloat(CommonConst.textBlankHeight)
        let y11 = y10 - CGFloat(CommonConst.textBlankHeight)
        let y12 = y11 - CGFloat(CommonConst.textBlankHeight)
        let y13 = y12 - CGFloat(CommonConst.textBlankHeight + 10)

        
        showStatusWithoutUp("hp",               display_key: "HP",  y: y3)
        showStatus("str",   up_key: "str_up",   display_key: "筋力", y: y4)
        showStatus("def",   up_key: "def_up",   display_key: "体力", y: y5)
        showStatus("int",   up_key: "int_up",   display_key: "知恵", y: y6)
        showStatus("pri",   up_key: "pri_up",   display_key: "精神", y: y7)
        showStatus("agi",   up_key: "agi_up",   display_key: "敏捷", y: y8)
        showStatus("luck",  up_key: "luck_up",  display_key: "幸運", y: y9)
        
        var label : SKLabelNode = SKLabelNode(fontNamed: CommonConst.font_regular)
        label.text = "※ カッコ内の数字は成長率"
        label.fontSize = CGFloat(CommonConst.font_size_normal)
        label.position = CGPointMake(CGRectGetMidX(self.frame), y10)
        self.addChild(label)
        
        var costLabel : SKLabelNode = SKLabelNode(fontNamed: CommonConst.font_regular)
        costLabel.text = "LVアップに必要な金： \(_cost)"
        costLabel.fontSize = CGFloat(CommonConst.font_size_normal)
        costLabel.position = CGPointMake(CGRectGetMidX(self.frame), y11)
        self.addChild(costLabel)

        if CommonData.getDataByInt("gold") >= _cost {
            var lvUp = CommonUI.normalButton("LVアップする", name: "lv_up", point: CGPointMake(CGRectGetMidX(self.frame), y12))
            self.addChild(lvUp)
        }
        
        setRealButton(y13)
        setSkillButton(y13)
    }
    
    func setRealButton(point_y : CGFloat) {
        let point : CGPoint = CGPoint(x:CGRectGetMidX(self.frame) - 70, y: point_y)
        let startButton: SKSpriteNode = CommonUI.normalButton("現実に戻る", name: "back", point: point)
        self.addChild(startButton)
    }
    
    func setSkillButton(point_y : CGFloat) {
        let point : CGPoint = CGPoint(x:CGRectGetMidX(self.frame) + 70, y:point_y)
        let startButton: SKSpriteNode = CommonUI.normalButton("スキルを見る", name: "skill", point: point)
        self.addChild(startButton)
    }

    func showStatus(key: String, up_key: String, display_key: String, y: CGFloat){
        var label : SKLabelNode = SKLabelNode(fontNamed: CommonConst.font_regular)
        let val : Int = CommonData.getData(key) as! Int
        let up_val : Int = CommonData.getData(up_key) as! Int
        label.text = "\(display_key) : \(val) (\(up_val))"
        label.fontSize = CGFloat(CommonConst.font_size_normal)
        label.position = CGPointMake(CGRectGetMidX(self.frame), y)
        self.addChild(label)
    }

    func showStatusWithoutUp(key: String, display_key: String, y: CGFloat){
        var label : SKLabelNode = SKLabelNode(fontNamed: CommonConst.font_regular)
        let val : Int = CommonData.getData(key) as! Int
        label.text = "\(display_key) : \(val)"
        label.fontSize = CGFloat(CommonConst.font_size_normal)
        label.position = CGPointMake(CGRectGetMidX(self.frame), y)
        self.addChild(label)
    }
    
    // タッチイベント
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as? UITouch
        let location = touch!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(location)
        if (touchedNode.name != nil) {
            if touchedNode.name == "back" {
                goGameSceneWithClose()
            } else if touchedNode.name == "lv_up" {
                levelUp()
            } else if touchedNode.name == "skill" {
                goSkill()
            }
        }
    }
    
    // ドアを閉じるモーションでゲーム画面へ
    func goGameSceneWithClose(){
        let secondScene = GameScene(size: self.frame.size)
        let tr = SKTransition.doorsCloseHorizontalWithDuration(1)
        changeSceneWithLongDuration(secondScene, tr: tr)
    }
    
    // レベルアップを行うと画面更新のため、いまいる画面に遷移する
    func levelUp(){
        CommonData.lvUp()
        CommonData.minus("gold", value: _cost)
        setMoney()
        
        let secondScene = StatusScene(size: self.frame.size)
        changeSceneWithoutTr(secondScene)
    }
    
    // スキルページへと繊維。ページ数は1
    func goSkill(){
        CommonData.setData("skill_page", value: 1)
        let skView = self.view! as SKView
        let secondScene = SkillScene(size: self.frame.size)
        let tr = SKTransition.crossFadeWithDuration(1)
        changeSceneWithLongDuration(secondScene, tr: tr)
    }

    override func update(currentTime: CFTimeInterval) {
    }
}