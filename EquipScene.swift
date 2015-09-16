// アイテム装備
import SpriteKit
class EquipScene: BaseScene {
    
    let _equip : String = CommonData.getDataByString("equip_weapon")
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red:0.1,green:0.0,blue:0.1,alpha:1.0)
        setMoney()
        setHeader()
        setBackButton("戻る")
    
        let point_y1 : CGFloat = CGRectGetMaxY(self.frame) - CGFloat(CommonConst.headerHeight + CommonConst.textBlankHeight*2)
        let point_y2 : CGFloat = point_y1 - CGFloat(CommonConst.textBlankHeight * 2)
        let point_y3 : CGFloat = point_y2 - CGFloat(CommonConst.textBlankHeight * 2)
        let point_y4 : CGFloat = point_y3 - CGFloat(CommonConst.textBlankHeight * 2)
        
        setText("武器名をタップすれば装備します。", key_name: "explain", point_y: point_y1)
        setWeapon("long", point_y: point_y2)
        setWeapon("katana", point_y: point_y3)
        setWeapon("shoes", point_y: point_y4)
    }
    
    func setWeapon(key_name: String, point_y: CGFloat){
        var weapon_label : SKLabelNode = SKLabelNode(fontNamed: CommonConst.font_regular)
        weapon_label.position = CGPointMake(100, point_y)
        weapon_label.fontSize = CGFloat(CommonConst.font_size_normal)
        
        // 所持していたらアイテム名を表示。未所持だったら???を表示
        if CommonData.getDataByInt("weapon_\(key_name)") == 0 {
            weapon_label.text = "?????"
            self.addChild(weapon_label)
        } else {
            let weapon_name = WeaponSetting.getName(key_name)
            
            // 装備中かどうか
            if _equip != key_name {
                weapon_label.text = weapon_name
                weapon_label.name = "equip_\(key_name)"
            } else {
                weapon_label.text = "[装備]\(weapon_name)"
                weapon_label.name = "equip_off_\(key_name)"
            }
            self.addChild(weapon_label)
            
            // はてなを表示
            var hatena = SKSpriteNode(imageNamed: "hatena.gif")
            hatena.name = "hatena_\(key_name)"
            hatena.position = CGPointMake(weapon_label.position.x + CGFloat(weapon_label.frame.width/2) + 30, point_y + 10)
            self.addChild(hatena)
        }
    }
    
    
    
    // タッチイベント
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as? UITouch
        let location = touch!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(location)
        if (touchedNode.name != nil) {
            if touchedNode.name == "back" {
                goGameSceneWithClose()
            } else if touchedNode.name == "hatena_long" {
                showAlert(WeaponSetting.getName("long"), text: WeaponSetting.getExplain("long"), ok_text: "なるほどねー")
            } else if touchedNode.name == "hatena_katana" {
                    showAlert(WeaponSetting.getName("katana"), text: WeaponSetting.getExplain("katana"), ok_text: "へぇー")
            } else if touchedNode.name == "hatena_shoes" {
                showAlert(WeaponSetting.getName("shoes"), text: WeaponSetting.getExplain("shoes"), ok_text: "ふむふむ")
            } else if touchedNode.name == "equip_long" {
                CommonData.setData("equip_weapon", value: "long")
                        let secondScene = EquipScene(size: self.frame.size)
                changeSceneWithoutTr(secondScene)
            } else if touchedNode.name == "equip_katana" {
                CommonData.setData("equip_weapon", value: "katana")
                let secondScene = EquipScene(size: self.frame.size)
                changeSceneWithoutTr(secondScene)
            } else if touchedNode.name == "equip_shoes" {
                CommonData.setData("equip_weapon", value: "shoes")
                let secondScene = EquipScene(size: self.frame.size)
                changeSceneWithoutTr(secondScene)
            }
        }
    }
    
    // ドアを閉じるモーションでゲーム画面へ
    func goGameSceneWithClose(){
        let secondScene = GameScene(size: self.frame.size)
        let tr = SKTransition.doorsCloseHorizontalWithDuration(1)
        changeSceneWithLongDuration(secondScene, tr: tr)
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
}