# -*- coding: utf-8 -*-
=begin
 Event Extender 5
 EventPrinter Module
 ===============================================================================
 http://www.biloucorp.com
 ===============================================================================
 By Zangther (API) and Nuki (GUI)
 
=end

#==============================================================================
module Vocab::Event
  extend self
  #--------------------------------------------------------------------------
  # Commands Vocab
  #--------------------------------------------------------------------------
  # Misc
  Name = "[%s]"
  Group = "%04d..%04d"
  VariableName = "%04d:%s"
  MoreOrLess = ["ou plus", "ou moins"]
  Command = "| >"
  Vehicle = ["Radeau", "Bateau", "Vaisseau"]
  Operators = ["=", "+=", "-=", "*=", "/=", "%="]
  Wait = "Attendre : %d Frames"
  SwitchOnOff = ["Désactiver", "Activer"]
  WaitEnd = ", Attendre"
  
  # Battlers
  Attributes = ["Niveau", "Expérience", "PV", "PM", "PV Maximum", "PM Maximum", 
          "Attaque", "Défense", "Magie", "Déf. Magique", "Agilité", "Chance"]
  
  # Evenements
  HeroEvent = "Héros"
  ThisEvent = "Cet événement"
  
  # Dialogues
  Message =  "Message :"
  MessageParams = "%s, %s, %s, %s"
  MessagePosition = ["Bas", "Milleu", "Haut"]
  MessageDisplay = ["Normal", "Transparent", "Sombre"]
  Void = "Ø"
  
  Choices = "Afficher Choix :"
  Choice = "Si %s - Faire"
  CancelChoice = "Annulation"
  EndChoice = "Fin - Choix"
  
  GetVar = "Entrer un Nombre - Stocker dans la variable %s, %d Chiffre(s)"
  
  SelectItem = "Sélection d'un objet : %s"
  
  DisplayScrollingText = "Afficher un texte défilant :"
  ScrollSpeed = "Vitesse %d"
  DisableFastForward = ", Désactiver l'avance rapide"
  
  # Operations on variables
  Operation = "Opération :"
  
  Switch = "Interrupteur"
  LocalSwitch = "Interrupteur local"
  OnOff = ["Activé", "Désactivé"]
  
  Variable = "Variable"
  ValueOfVariable = "(la valeur de la variable %s)"
  RandomValue = "(valeur aléatoire entre %d et %d)"
  NumberOf = "%s possédés"
  EventParam = ["Coordonée X", "Coordonée Y", "Direction", "Coordonée X à l'écran", "Coordonée Y à l'écran"]
  OtherVariable = ["ID de la carte", "Nombre de personnage dans l'équipe", "Argent possédé", 
        "Nombre total de pas", "Temps de jeu", "Chronomètre", "Nombre de sauvegardes", "Nombre de combats"]
  IdOfAMember = "ID du %s membre"
  OrdinalNumber = ["1er", "2ème", "3ème", "4ème", "5ème", "6ème", "7ème", "8ème"]
  
  Chronometer = "Gestion  du Chronomètre :"
  LeChronometer = "le Chronomètre est"
  Time = "à %d Minutes et %d Secondes"
  Start = "Démarrer (" + Time + ")"
  Stop = "Arrêter"
  
  # Conditions
  Condition = "Condition :"
  ComparationOperator = ["==", ">=", "<=", ">", "<", "!="]
  HeroConditions = ["est dans l'équipe", "a pour nom '%s'", "a comme classe %s", "a la compétence %s", 
      "est équipé avec l'arme %s", "est équipé avec l'armure %s", "est sous l'effet de statut %s"]
  MoneyCondition = "l'argent possédé est de %d %s"
  ItemCondition = "l'objet %s est possédé"
  WeaponCondition = "l'arme %s est possédée%s"
  ArmorCondition = "l'armure %s est possédée%s"
  OrEquipped = ", ou équipée"
  KeyCondition = "la touche %s est pressée"
  VehicleCondition = "le véhicule [%s] est utilisé"
  Present = "est présent"
  ScriptCondition = "Script : %s"
  Else = "Sinon"
  EndCondition = "Fin - Condition"
  
  # Functions
  CommonEventCall = "Appeler Événement Commun :"
  
  Loop = "Boucle"
  EndLoop = "Fin - Boucle"
  ExitLoop = "Sortir de la Boucle"
  
  Goto = "Étiquette :"
  GotoCall = "Aller à l'Étiquette :"      
  
  StopEvents = "Arrêter les évènements"
  
  Comment = "Commentaire :"
  
  
  # Music / Video
  Music = "'%s', Volume : %d, Tempo : %d"
  BGM = "Jouer BGM :"
  MemorizeBGM = "Mémoriser la musique (BGM)"
  RestartBGM = "Reprendre la musique (BGM)"
  BGS = "Jouer BGS :"
  ME = "Jouer ME :"
  SE = "Jouer SE :"
  StopBGM = "Arrêter en fondu de la BGM : %s Secondes"
  StopBGS = "Arrêter en fondu du BGS : %s Secondes"
  StopSE = "Arrêter SE"
  PlayVideo = "Jouer une vidéo : '%s'"
  
  # Battle
  Battle = "Démarrer un combat : %s"
  BattleIndexed = "(Indexé par [%04d])"
  IfVictory = "Si Victoire - Faire"
  IfFlee = "Si Fuite - Faire"
  IfLoss = "Si Défaite - Faire"
  EndBattle = "Fin - Combat"
  AllEnemies = "Tous les ennemis"
  Enemy = "[%d. %s]"
  
  # Game
  Shop = "Appeler magasin :"
  EnterName = "Enter le nom d'un personnage : %s, %d Lettres"
  OpenMenu = "Ouvrir le menu principal"
  OpenSave = "Ouvrir le menu de sauvegarde"
  GameOver = "Game Over"
  ToTitle = "Retourner à l'écran titre"
  
  # System  
  ModifyBGM = "Modifier BGM de combat :"
  ModifyME = "Modifier ME de victoire :"
  ModifiySave = "Modifier l'accès aux sauvegardes :"
  ModifiyMenu = "Modifier l'accès au menu :"
  ModifiyEncounter = "Modifier les rencontres :"
  ModifiyFormation = "Formation de l'équipe :"
  WindowColor = "Affichage du nom de la carte : %s"
  ModifyHeroAppearance = "Modifier Apparence Personnage : %s, Charset:'%s', 0, Faceset:'%s', 0"
  ModifyVehicleAppearance = "Modifier Apparence Véhicule : [%s], '%s', 0"
  
  # Script
  ScriptCall = "Appeler Script :"
  
  # Manage
  WholeTeam = "Équipe Entière"
  ModifyMoney = "Modifier Argent :"
  ModifyItem = "Modifier Objet :"
  ModifyWeapon = "Modifier Armes :"
  ModifyArmor = "Modifier Armures :"
  ModifyParty = "Modifier l'équipe :"
  ModifyTextWithIncluded = "%s, Inclure l'équipement"
  ModifyPartyTextWithReset = "%s, Démarre au niveau initial"
  ModifyHP = "Modifier PV :"
  ModifyMP = "Modifier PM :"
  ModifyStatus = "Modifier Status : %s,"
  Recover = "Récupération complète :"
  ModifyExperience = "Modifier Expérience : %s,"
  ModifyLevel = "Modifier Niveau : %s,"
  ModifyParameters = "Modifier Caractéristique : %s,"
  ModifySkill = "Modifier Compétence : %s,"
  ModifyEquipement = "Modifier Équipement : %s,"
  ModifyHeroName = "Modifier Nom Personnnage : %s,"
  ModifyHeroAlias = "Modifier Surnom Personnnage : %s,"
  ModifyHeroClass = "Modifier Classe Personnage : %s,"
  RestoreEnemy = "Récupération Complète - "
  PlusOrMinus = ["+", "-"]
  AddOrRemove = ["Ajouter", "Retirer"] 
  Equipement = ["Armes", "Bouclier", "Casque", "Armure", "Accessoire"]     
  
  # Battle
  ModifyHPEnemy = "Modifier PV - Ennemi : %s,"
  ModifyMPEnemy = "Modifier PM - Ennemi  : %s,"
  ModifyStatusEnemy = "Modifier Status - Ennemi : %s,"
  RecoverEnemy = "Récupération Complète - Ennemi : %s"
  RevealEnemy = "Apparition ennemi caché : %s"
  MorphEnemy = "Transformer l'ennemi : %s en %s"
  DisplayBattleAnimation = "Afficher animation de combat : %s,"
  Battler = "Personnage n°%d"
  LastTarget = "Dernière Cible"
  RandomTarget = "Cible Aléatoire"
  Target = "Cible n°%d"
  ForceAction = "Forcer action : %s, %s, %s"
  EndTheBattle = "Terminer le combat"

  # Warp
  Warp = "Téléporter l'équipe :"
  PlaceVehicle = "Placer véhicule :"
  PlaceEvent = "Placer événement : %s, %s"
  SwapPositions = "échanger la position avec [%s]"
  Position = ["(X: %03d, Y: %03d)", "X: [%04d], Y: [%04d]", "échanger la position avec %s"]
  
  # Deplacement 
  IsLooking = "Regarde vers"
  Direction = {0 => "", 2 => ", le Bas", 4 => ", la Gauche", 6 => ", la Droite", 8 => ", le Haut"}
  
  # Input
  Inputs = { 2 =>"Bas", 4 => "Gauche", 6 => "Droite", 8 => "Haut", 11 => "A", 12 => "B", 13 => "C", 14 => "X",
      15 => "Y", 16 => "Z", 17 => "L", 18 => "R" }
      
  # Move route
  MoveEvent = "Déplacer évènement :"
  MoveRouteParams = ["Répéter", "Ignorer action impossible", "Attendre la fin"]
  MoveRouteCommands = ["", "Un pas vers le Bas", "Un pas vers la Gauche", "Un pas vers la Droite", 
  "Un pas vers le Haut", "Un pas vers Bas-Gauche", "Un pas vers Bas-Droite", "Un pas vers Haut-Gauche", 
  "Un pas vers Haut-Droite", "Un pas au Hasard", "Un pas vers le Héros",  "Fuis le héros d'un pas",  
  "Un pas en Avant",  "Un pas en Arrière", "Saut : %s en X, %s en Y", "Attendre : %d Frames", 
  "Regarde vers le Bas", "Regarde vers la Gauche", "Regarde vers la Droite", "Regarde vers le Haut", 
  "Quart de tour à Droite", "Quart de tour à Gauche", "Demi tour", "Quart de tour au Hasard", 
  "Regarde Direction Aléat.", "Regarde vers le héros", "Se détourne du héros", "Active Inter. : %04d", 
  "Désactive Inter. : %04d", "Modifier Vitesse. : %d", "Modifier Fréquence : %d", "Marche animée ON", 
  "Marche animée OFF", "Animé à l'arrêt ON", "Animé à l'arrêt OFF", "Direction fixe ON", "Direction fixe OFF", 
  "Passe-muraille ON", "Passe-muraille OFF", "Transparent ON", "Transparent OFF", "Modifier charset : %s", 
  "Modifier opacité : %d", "Modifier transp. : %s", "Jouer un SE : %s", 
  "Appeller Script : %s"]
  
  # Visual
  Caterpillar = "Chenille :"
  RegroupCaterpillar = "Regrouper la chenille"
  Transparency = ["Normale", "Éclaircie", "Obscurcie"]
  ScrollMap = "Faire défiler la carte vers"
  ScrollMapParams = "de %d carreaux, vitesse %d"
  EnterExitVehicle = "Entrer/Sortir du véhicule"
  
  Opacity = ["Transparent", "Opaque"]
  SetOpacity = "Transparence du héros :"
  DisplayAnimation = "Afficher une animation : Cible - %s,"
  DisplayEmote = "Afficher une émoticône : Cible - %s,"
  DeleteEvent = "Effacer cet événement"
  Emotes = ["Exclamation", "Interrogation", "Note de Musique", "Coeur", "Colère", 
    "Goute", "Toile", "Silence", "Ampoule", "Zzz"]
    
  # Appearance
  None = "(aucun)"
  
  # Visual Effects
  Color = ["(R:%d,V:%d,B:%d,I:%d)", "(R:%d,V:%d,B:%d)"]
  Tone = "(R:%d,V:%d,B:%d,G:%d)"
  FadeIn = "Effacer l'écran en fondu"
  FadeOut = "Afficher l'écran en fondu"
  ScreenTone = "Ton de l'écran : %s, %d Frames%s"
  FlashScreen = "Flasher l'écran : %s, %d Frames%s"
  ShakeScreen = "Secouer l'écran : Force %d, Vitesse %d, %d Frames%s"
  
  # Pictures
  DisplayPicture = "Afficher une image : %d, '%s', %s %s, (%d%%,%d%%), %d, %s"
  MovePicture = "Afficher une image : %d, '%s', %s %s, (%d%%,%d%%), %d, %s, %d Frames%s"
  PositionPicture = [["H.G.", "Ctre"], ["(%d,%d)", "(X:[%04d], Y:[%04d])"]]
  RotatePicture = "Rotation Image : %d, Vitesse %s%d"
  TonePicture = "Ton Image : %d, %s, %d Frames%s"
  DeletePicture = "Effacer Image : %d"
  WeatherEffect = "Effet Météorologique : %s, %d Frames%s"
  Weather = {none: "Aucun", rain: "Pluie, %d", storm: "Orage, %d", snow: "Neige, %d"}
  
  # Graphics
  DisplayMapName = "Affichage du nom de la carte :"
  ChangeTileset = "Changer de tileset :"
  ChangeBattleBack = ["Changer le fond de combat : %s", "Changer le fond de combat : %s & %s"]
  ChangePanorama = "Changer de panorama : '%s'"
  GetInformation = "Récupérer des informations : [%04d], %s,"
  GetInformationCoord = ["(%03d,%03d)", "Variable [%04d][%04d]"]

  #--------------------------------------------------------------------------
  # * Get switch name
  #--------------------------------------------------------------------------
  def switch_name(id)
    return name(sprintf("%04d", id)) if DataManager.system.switches[id] == ""
    name(sprintf(Vocab::Event::VariableName, id,  DataManager.system.switches[id]))
  end
  #--------------------------------------------------------------------------
  # * Get variable name
  #--------------------------------------------------------------------------
  def variable_name(id)
    return name(sprintf("%04d", id)) if  DataManager.system.variables[id] == ""
    name(sprintf(Vocab::Event::VariableName, id,  DataManager.system.variables[id]))
  end
  #--------------------------------------------------------------------------
  # * Get the variable name
  #--------------------------------------------------------------------------
  def la_variable(id)
    Vocab::Event::Variable + " " + variable_name(id)
  end
  #--------------------------------------------------------------------------
  # * Get group name
  def group_name(id1, id2)
    name(sprintf(Vocab::Event::Group, id1, id2))
  end
  #--------------------------------------------------------------------------
  # * Get group or uniq variable
  #--------------------------------------------------------------------------
  def group_or_uniq(id1, id2, switch = true)
    if id1 == id2
      switch ? switch_name(id1) : variable_name(id1)
    else
      group_name(id1, id2)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Event Name
  #--------------------------------------------------------------------------
  def event_name(id, map)
    case id
    when -1; Vocab::Event::HeroEvent
    when 0; Vocab::Event::ThisEvent
    else; sprintf(Vocab::Event::Name, map.events[id].name)
    end
  end
  #--------------------------------------------------------------------------
  # * Get the map name
  #--------------------------------------------------------------------------
  def map_name(id)
    DataManager.mapinfos.find{ |map| map[1].parent_id = id }[1].name
  end
  #--------------------------------------------------------------------------
  # * Get hero name
  #--------------------------------------------------------------------------
  def tileset_name(id)
    tilesets[id].name
  end
  #--------------------------------------------------------------------------
  # * Get hero name
  #--------------------------------------------------------------------------
  def hero_name(id)
    id == 0 ? Vocab::Event::WholeTeam : name(DataManager.actors[id].name)
  end
  #--------------------------------------------------------------------------
  # * Get class name
  #--------------------------------------------------------------------------
  def class_name(id)
    name(DataManager.classes[id].name)
  end
  #--------------------------------------------------------------------------
  # * Get a foe name (in battle)
  def foe_name(id, event)
    return Vocab::Event::AllEnemies if id == -1
    sprintf(Vocab::Event::Enemy, id + 1, event.troop.empty? ? "" : enemy_name(event.troop[id].enemy_id, false))
  end
  #--------------------------------------------------------------------------
  # * Get a certain type of item name 
  #   **(type : 0 => Item, 1 => Weapon, 2 => Armor)
  #--------------------------------------------------------------------------
   def base_item_name(type, id)
    type == 0 ? item_name(id) : equipement_name(type-1, id)
  end
  #--------------------------------------------------------------------------
  # * Get item name
  #--------------------------------------------------------------------------
  def item_name(id)
    name(DataManager.items[id].name)
  end
  #--------------------------------------------------------------------------
  # * Get skill name
  #--------------------------------------------------------------------------
  def skill_name(id)
    name(DataManager.skills[id].name)
  end
  #--------------------------------------------------------------------------
  # * Get an certain type of equipement name
  #--------------------------------------------------------------------------
  def equipement_name(type, id)
    return Vocab::Event::None if id == 0
    type == 0 ? weapon_name(id) : armor_name(id)
  end
  #--------------------------------------------------------------------------
  # * Get weapon name
  #--------------------------------------------------------------------------
  def weapon_name(id)
   name(DataManager.weapons[id].name)
  end
  #--------------------------------------------------------------------------
  # * Get armor name
  #--------------------------------------------------------------------------
  def armor_name(id)
   name(DataManager.armors[id].name)
  end
  #--------------------------------------------------------------------------
  # * Get state name
  #--------------------------------------------------------------------------
  def state_name(id)
    name(DataManager.states[id].name)
  end
  #--------------------------------------------------------------------------
  # * Get common event name
  #--------------------------------------------------------------------------
  def common_event_name(id)
    name(DataManager.common_events[id].name)
  end
  #--------------------------------------------------------------------------
  # * Get animation name 
  #--------------------------------------------------------------------------
  def animation_name(id)
    name(DataManager.animations[id].name)
  end
  #--------------------------------------------------------------------------
  # * Get enemy name
  #--------------------------------------------------------------------------
  def enemy_name(id, with_brackets = true)
    with_brackets ? name(DataManager.enemies[id].name)  : DataManager.enemies[id].name
  end
  #--------------------------------------------------------------------------
  # * Put the string between [ and ]
  #--------------------------------------------------------------------------
  def name(string)
    sprintf(Vocab::Event::Name, string)
  end
  #--------------------------------------------------------------------------
  # * Get a target's name
  #--------------------------------------------------------------------------
  def target_name(id)
    case id
    when -2;  Vocab::Event::LastTarget
    when -1;  Vocab::Event::RandomTarget;
    else;     sprintf(Vocab::Event::Target, id+1); end
  end
end
  # End of Vocab::Event  ------------------------------------------------------------------------------------------------

module EventPrinter
  #==============================================================================
  # ** EventCommand
  #------------------------------------------------------------------------------
  #  Handle the conversion form code, indent and parameters to a representation
  #==============================================================================
  class EventCommand
    #--------------------------------------------------------------------------
    # * Public Instance Variables
    #--------------------------------------------------------------------------
    attr_reader :event
    #--------------------------------------------------------------------------
    # * Hash which convert event command to a array representation
    #     ** Lambdas => should return a array like :
    #        [ true|false (Put the > or not)
    #           {color: :some_color_symbol, text: "Some text" }
    #           {color: :some_other_color_symbol, text: "Some other text" } ]
    #--------------------------------------------------------------------------
    CommandHash = {
      0 => ->(params, event){ [true] },
      101 => ->(params, event){ [true,
        {color: :standard,    text: Vocab::Event::Message}, 
        {color: :parameters, text: sprintf(Vocab::Event::MessageParams, 
          params[0].empty? ? Vocab::Event::Void : "'#{params[0]}'", params[0].empty? ? 
          Vocab::Event::Void : params[1].to_s, Vocab::Event::MessageDisplay[params[2]], 
          Vocab::Event::MessagePosition[params[3]])}
        ]},
      102 => ->(params, event){ [true,
        {color: :standard, text: Vocab::Event::Choices},
        {color: :text,           text: params[0].join(", ")}] },
      103 => ->(params, event){ [true,
        {color: :standard, text: sprintf(Vocab::Event::GetVar, 
          Vocab::Event::variable_name(params[0]), params[1])}] },
      104 => ->(params, event){ [true,
        {color: :standard, text: sprintf(Vocab::Event::SelectItem, 
          Vocab::Event::variable_name(params[0]))}] },
      105 => ->(params, event){ [true,
        {color: :standard, text: Vocab::Event::DisplayScrollingText},
        {color: :parameters, text: sprintf(Vocab::Event::ScrollSpeed, params[0])},
        {color: :parameters, text: (params[1] ? Vocab::Event::DisableFastForward : "")}] },
      108 => ->(params, event){ [true,
        {color: :comments, text: Vocab::Event::Comment},
        {color: :comments, text: params[0]}] },
      111 => ->(params, event){ [true,
        {color: :function, text: Vocab::Event::Condition},
        {color: :function, text: ConditionArray[params[0]].call(params[1..-1], event) }]},
      112 => ->(params, event){ [true,
        {color: :function, text: Vocab::Event::Loop}]},
      113 => ->(params, event){ [true,
        {color: :function, text: Vocab::Event::ExitLoop}]},
      115 => lambda { |params, event| [true,
        {:color => :function, :text => Vocab::Event::StopEvents}]},
      117 => ->(params, event){ [true,
        {color: :function, text: Vocab::Event::CommonEventCall},
        {color: :function, text: Vocab::Event::common_event_name(params[0])}
        ]},
      118 => ->(params, event){ [true,
        {color: :function, text: Vocab::Event::Goto},
        {color: :function, text: params[0]}
        ]},
      119 => ->(params, event){ [true,
        {color: :function, text: Vocab::Event::GotoCall},
        {color: :function, text: params[0]}
        ]},
      121 => ->(params, event){ [true,
        {color: :variables, text: Vocab::Event::Operation},
        {color: :variables, text: Vocab::Event::Switch},
        {color: :variables, text: Vocab::Event::group_or_uniq(params[0], params[1], true)},
        {color: :variables, text: Vocab::Event::OnOff[params[2]]}] },
      122 => ->(params, event){ [true,
        {color: :variables, text: Vocab::Event::Operation},
        {color: :variables, text: Vocab::Event::Variable},
        {color: :variables, text: Vocab::Event::group_or_uniq(params[0], params[1], false)},
        {color: :variables, text: Vocab::Event::Operators[params[2]]}, 
        {color: :variables, text: OperandArray[params[3]].call(params[4..-1], event)} ]},
      123 => ->(params, event){ [true,
        {color: :variables, text: Vocab::Event::Operation},
        {color: :variables, text: Vocab::Event::LocalSwitch},
        {color: :variables, text: params[0]},
        {color: :variables, text: Vocab::Event::Operators[0]}, 
        {color: :variables, text: Vocab::Event::OnOff[params[1]]}]},
      124 => ->(params, event){ [true,
        {color: :variables, text: Vocab::Event::Chronometer},
        {color: :variables, text: params[0] == 0 ? sprintf(Vocab::Event::Start, 
          params[1] / 60, params[1] % 60) : Vocab::Event::Stop
        }] },
      125 => ->(params, event){ [true,
        {color: :manage, text: Vocab::Event::ModifyMoney},
        {color: :manage, text: Vocab::Event::PlusOrMinus[params[0]]},
        {color: :manage, text: params[1] == 0 ? params[2].to_s : Vocab::Event::la_variable(params[2])}
        ] },
      126 => ->(params, event){ [true,
        {color: :manage, text: Vocab::Event::ModifyItem},
        {color: :manage, text: Vocab::Event::item_name(params[0])},
        {color: :manage, text: Vocab::Event::PlusOrMinus[params[1]]},
        {color: :manage, text: params[2] == 0 ? params[3].to_s : Vocab::Event::la_variable(params[3])}
        ] },
      127 => ->(params, event){ [true,
        {color: :manage, text: Vocab::Event::ModifyWeapon},
        {color: :manage, text: Vocab::Event::weapon_name(params[0])},
        {color: :manage, text: Vocab::Event::PlusOrMinus[params[1]]},
        {color: :manage, text: sprintf(
          params[1] == 1 && params[4] ? Vocab::Event::ModifyTextWithIncluded : "%s",
          params[2] == 0 ? params[3].to_s : Vocab::Event::la_variable(params[3]))}
        ] },
      128 => ->(params, event){ [true,
        {color: :manage, text: Vocab::Event::ModifyArmor},
        {color: :manage, text: Vocab::Event::armor_name(params[0])},
        {color: :manage, text: Vocab::Event::PlusOrMinus[params[1]]},
        {color: :manage, text: sprintf(
          params[1] == 1 && params[4] ? Vocab::Event::ModifyTextWithIncluded : "%s",
          params[2] == 0 ? params[3].to_s : Vocab::Event::la_variable(params[3]))}
        ] },
      129 => ->(params, event){ [true,
        {color: :manage, text: Vocab::Event::ModifyParty},
        {color: :manage, text: Vocab::Event::AddOrRemove[params[1]]},
        {color: :manage, text: sprintf(
          params[1] == 0 && params[2] == 1 ? Vocab::Event::ModifyPartyTextWithReset : "%s",
          Vocab::Event::hero_name(params[0]))}
        ] }, 
      132 => ->(params, event){ [true,
        {color: :system, text: Vocab::Event::ModifyBGM},
        {color: :system, text: params[0].to_string_params}
        ] },  
      133 => ->(params, event){ [true,
        {color: :system, text: Vocab::Event::ModifyME},
        {color: :system, text: params[0].to_string_params}
        ] },  
      134 => ->(params, event){ [true,
        {color: :system, text: Vocab::Event::ModifiySave},
        {color: :system, text: Vocab::Event::SwitchOnOff[params[0]]}
        ] },  
      135 => ->(params, event){ [true,
        {color: :system, text: Vocab::Event::ModifiyMenu},
        {color: :system, text: Vocab::Event::SwitchOnOff[params[0]]}
        ] },  
      136 => ->(params, event){ [true,
        {color: :system, text: Vocab::Event::ModifiyEncounter},
        {color: :system, text: Vocab::Event::SwitchOnOff[params[0]]}
        ] },  
      137 => ->(params, event){ [true,
        {color: :system, text: Vocab::Event::ModifiyFormation},
        {color: :system, text: Vocab::Event::SwitchOnOff[params[0]]}
        ] },  
      138 => ->(params, event){ [true,
        {color: :system, text: sprintf(Vocab::Event::WindowColor, params[0].to_string_params)}
        ] },  
      201 => ->(params, event){ [true,
        {color: :events, text: Vocab::Event::Warp},
        {color: :events, text: WarpText[params[0]].call(params[1..-1]) + 
          Vocab::Event::Direction[params[4]] }
        ] },
      202 => ->(params, event){ [true,
        {color: :events, text: Vocab::Event::PlaceVehicle},
        {color: :events, text: Vocab::Event::Vehicle[params[0]]},
        {color: :events, text: WarpText[params[1]].call(params[2..-1])}
      ] },
      203 => ->(params, event){ [true,
        {color: :events, text: (sprintf(Vocab::Event::PlaceEvent, 
          Vocab::Event::event_name(params[0], event.map), PositionArray[params[1]].call(params[2..-1], event)
          ) + Vocab::Event::Direction[params[4]])} 
      ]},
      204 => ->(params, event){ [true,
        {color: :events, text: Vocab::Event::ScrollMap},
        {color: :events, text: Vocab::Event::Direction[params[0]]},
        {color: :events, text: sprintf(Vocab::Event::ScrollMapParams, *params[1..-1])} ]},
      205 => ->(params, event){ [true,
        {color: :events, text: Vocab::Event::MoveEvent},
        {color: :events, text: Vocab::Event::event_name(params[0], event.map)},
        {color: :events, text: params[1].to_string_params } ]},
      206 => ->(params, event){ [true,
        {color: :events, text: Vocab::Event::EnterExitVehicle}
      ]},
      211 => ->(params, event){ [true,
        {color: :events, text: Vocab::Event::SetOpacity},
        {color: :events, text: Vocab::Event::Opacity[params[0]]}
      ]},
      212 => ->(params, event){ [true,
        {color: :events, text: sprintf(Vocab::Event::DisplayAnimation, 
          Vocab::Event::event_name(params[0], event.map))},
        {color: :events, text: Vocab::Event::animation_name(params[1])}
      ]},
      213 => ->(params, event){ [true,
        {color: :events, text: sprintf(Vocab::Event::DisplayEmote, 
          Vocab::Event::event_name(params[0], event.map))},
        {color: :events, text: Vocab::Event::Emotes[params[1]-1]}
      ]},
      214 => ->(params, event){ [true,
        {color: :events, text: Vocab::Event::DeleteEvent}
      ]},
      216 => ->(params, event){ [true,
        {color: :events, text: Vocab::Event::Caterpillar},
        {color: :events, text: Vocab::Event::OnOff[params[0]]}
      ]},
      217 => ->(params, event){ [true,
        {color: :events, text: Vocab::Event::RegroupCaterpillar}
      ]},
      221 => ->(params, event){ [true,
        {color: :events, text: Vocab::Event::FadeIn}
      ]},
      222 => ->(params, event){ [true,
        {color: :events, text: Vocab::Event::FadeOut}
      ]},
      223 => ->(params, event){ [true,
        {color: :events, text: sprintf(Vocab::Event::ScreenTone, params[0].to_string_params, params[1],
          params[2] ? Vocab::Event::WaitEnd : "")}
      ]},
      224 => ->(params, event){ [true,
        {color: :events, text: sprintf(Vocab::Event::FlashScreen, params[0].to_string_params, params[1],
          params[2] ? Vocab::Event::WaitEnd : "")}
      ]},
      225 => ->(params, event){ [true,
        {color: :events, text: sprintf(Vocab::Event::ShakeScreen, params[0], params[1],
          params[2], params[3] ? Vocab::Event::WaitEnd : "")}
      ]},
      230 => ->(params, event){ [true,
        {color: :wait, text: sprintf(Vocab::Event::Wait, params[0])}
      ]},
      231 => ->(params, event){ [true,
        {color: :pictures, text: sprintf(Vocab::Event::DisplayPicture, params[0], params[1], 
          Vocab::Event::PositionPicture[0][params[2]], sprintf(Vocab::Event::PositionPicture[1][params[3]], 
          params[4], params[5]), params[6], params[7], params[8], Vocab::Event::Transparency[params[9]])}
      ]},
      232 => ->(params, event){ [true,
        {color: :pictures, text: sprintf(Vocab::Event::MovePicture, params[0], params[1], 
          Vocab::Event::PositionPicture[0][params[2]], sprintf(Vocab::Event::PositionPicture[1][params[3]], 
          params[4], params[5]), params[6], params[7], params[8], Vocab::Event::Transparency[params[9]],
          params[10], params[11] ? Vocab::Event::WaitEnd : "")}
      ]},
      233 => ->(params, event){ [true,
        {color: :pictures, text: sprintf(Vocab::Event::RotatePicture, params[0], params[1] > 0 ? "+" : "", 
          params[1])}
      ]},
      234 => ->(params, event){ [true,
        {color: :pictures, text: sprintf(Vocab::Event::TonePicture, params[0], params[1].to_string_params, 
          params[2], params[3] ? Vocab::Event::WaitEnd : "")}
      ]},
      235 => ->(params, event){ [true,
        {color: :pictures, text: sprintf(Vocab::Event::DeletePicture, params[0])}
      ]},
      236 => ->(params, event){ [true,
        {color: :pictures, text: sprintf(Vocab::Event::WeatherEffect, 
          sprintf(Vocab::Event::Weather[params[0]], params[1]), params[2],
          params[3] ? Vocab::Event::WaitEnd : "")}
      ]},
      241 => ->(params, event){ [true,
        {color: :musics, text: Vocab::Event::BGM },
        {color: :musics, text: params[0].to_string_params },
      ]},
      242 => ->(params, event){ [true,
        {color: :musics, text: sprintf(Vocab::Event::StopBGM, params[0]) }
      ]},
      243 => ->(params, event){ [true,
        {color: :musics, text: Vocab::Event::MemorizeBGM }
      ]},
      244 => ->(params, event){ [true,
        {color: :musics, text: Vocab::Event::RestartBGM }
      ]},
      245 => ->(params, event){ [true,
        {color: :musics, text: Vocab::Event::BGS },
        {color: :musics, text: params[0].to_string_params },
      ]},
      246 => ->(params, event){ [true,
        {color: :musics, text: sprintf(Vocab::Event::StopBGS, params[0]) }
      ]},
      249 => ->(params, event){ [true,
        {color: :musics, text: Vocab::Event::ME },
        {color: :musics, text: params[0].to_string_params },
      ]},
      250 => ->(params, event){ [true,
        {color: :musics, text: Vocab::Event::SE },
        {color: :musics, text: params[0].to_string_params },
      ]},
      251 => ->(params, event){ [true,
        {color: :musics, text: Vocab::Event::StopSE }
      ]},
      261 => ->(params, event){ [true,
        {color: :musics, text: sprintf(Vocab::Event::PlayVideo, params[0]) }
      ]},
      281 => ->(params, event){ [true,
        {color: :graphics, text: Vocab::Event::DisplayMapName },
        {color: :graphics, text: Vocab::Event::OnOff[params[0]]}
      ]},
      282 => ->(params, event){ [true,
        {color: :graphics, text: Vocab::Event::ChangeTileset },
        {color: :graphics, text: Vocab::Event::tileset_name(params[0]) }
      ]},
      283 => ->(params, event){ [true,
        {color: :graphics, text: sprintf(Vocab::Event::ChangeBattleBack[params[1].empty? ? 0 : 1], *params)}
      ]},
      284 => ->(params, event){ [true,
        {color: :graphics, text: sprintf(Vocab::Event::ChangePanorama, *params)}
      ]},
      285 => ->(params, event){ [true,
        {color: :graphics, text: sprintf(Vocab::Event::GetInformation, *params)},
        {color: :graphics, text: sprintf(Vocab::Event::GetInformationCoord[params[2]], *params[3..4])}
      ]},
      301 => ->(params, event){ [true,
        {color: :game, text: sprintf(Vocab::Event::Battle, params[0] == 0 ? 
        Vocab::Event::enemy_name(params[1]) : sprintf(Vocab::Event::BattleIndexed, params[1]))}
        ] },
      302 => ->(params, event){ [true,
        {color: :game, text: Vocab::Event::Shop},
        {color: :game, text: Vocab::Event::base_item_name(*params[0..1])}
        ] },
      303 => ->(params, event){ [true,
        {color: :game, text: sprintf(Vocab::Event::EnterName, 
            Vocab::Event::hero_name(params[0])[1...-1], params[1])}
        ] },
      311 => ->(params, event){ [true,
        {color: :manage, text: Vocab::Event::ModifyHP},
        {color: :manage, text: params[0] == 0 ? Vocab::Event::hero_name(params[1]) : 
          [Vocab::Event::Variable, Vocab::Event::variable_name(params[1])].join(" ")},
        {color: :manage, text: Vocab::Event::PlusOrMinus[params[2]]},
        {color: :manage, text: params[3] == 0 ? params[4].to_s : Vocab::Event::la_variable(params[4])}
        ] },
      312 => ->(params, event){ [true,
        {color: :manage, text: Vocab::Event::ModifyMP},
        {color: :manage, text: params[0] == 0 ? Vocab::Event::hero_name(params[1]) : 
          [Vocab::Event::Variable, Vocab::Event::variable_name(params[1])].join(" ")},
        {color: :manage, text: Vocab::Event::PlusOrMinus[params[2]]},
        {color: :manage, text: params[3] == 0 ? params[4].to_s : Vocab::Event::la_variable(params[4])}
        ] },
      313 => ->(params, event){ [true,
        {color: :manage, text: sprintf(Vocab::Event::ModifyStatus, 
          Vocab::Event::hero_name(params[0]))},
        {color: :manage, text: Vocab::Event::PlusOrMinus[params[1]]},
        {color: :manage, text: sprintf(Vocab::Event::Name, Vocab::Event::state_name(params[2]))}
        ] },
      314 => ->(params, event){ [true,
        {color: :manage, text: Vocab::Event::Recover},
        {color: :manage, text: params[0] == 0 ? Vocab::Event::hero_name(params[1]) : 
          [Vocab::Event::Variable, Vocab::Event::variable_name(params[1])].join(" ")}
        ] },
      315 => ->(params, event){ [true,
        {color: :manage, text: sprintf(Vocab::Event::ModifyExperience, 
          params[0] == 0 ? Vocab::Event::hero_name(params[1]) : 
          [Vocab::Event::Variable, Vocab::Event::variable_name(params[1])].join(" "))},
        {color: :manage, text: Vocab::Event::PlusOrMinus[params[2]]},
        {color: :manage, text: params[3] == 0 ? params[4].to_s : Vocab::Event::la_variable(params[4])}
        ] },
      316 => ->(params, event){ [true,
        {color: :manage, text: sprintf(Vocab::Event::ModifyLevel, 
          params[0] == 0 ? Vocab::Event::hero_name(params[1]) : 
          [Vocab::Event::Variable, Vocab::Event::variable_name(params[1])].join(" "))},
        {color: :manage, text: Vocab::Event::PlusOrMinus[params[2]]},
        {color: :manage, text: params[3] == 0 ? params[4].to_s : Vocab::Event::la_variable(params[4])}
        ] },
      317 => ->(params, event){ [true,
        {color: :manage, text: sprintf(Vocab::Event::ModifyParameters, 
          params[0] == 0 ? Vocab::Event::hero_name(params[1]) : 
          [Vocab::Event::Variable, Vocab::Event::variable_name(params[1])].join(" "))},
        {color: :manage, text: Vocab::Event::Attributes[params[2] - 5]},
        {color: :manage, text: Vocab::Event::PlusOrMinus[params[3]]},
        {color: :manage, text: params[4] == 0 ? params[5].to_s : Vocab::Event::la_variable(params[5])}
        ] },
      318 => ->(params, event){ [true,
        {color: :manage, text: sprintf(Vocab::Event::ModifySkill, 
          params[0] == 0 ? Vocab::Event::hero_name(params[1]) : 
          [Vocab::Event::Variable, Vocab::Event::variable_name(params[1])].join(" "))},
        {color: :manage, text: Vocab::Event::PlusOrMinus[params[2]]},
        {color: :manage, text: Vocab::Event::skill_name(params[3])}
        ] },
      319 => ->(params, event){ [true,
        {color: :manage, text: sprintf(Vocab::Event::ModifyEquipement, 
          Vocab::Event::hero_name(params[0]))},
        {color: :manage, text: Vocab::Event::Equipement[params[1]]},
        {color: :manage, text: Vocab::Event::Operators[0]},
        {color: :manage, text: Vocab::Event::equipement_name(params[1], params[2])}
        ] },
      320 => ->(params, event){ [true,
        {color: :manage, text: sprintf(Vocab::Event::ModifyHeroName,
          Vocab::Event::hero_name(params[0]))},
        {color: :manage, text: "'#{params[1]}'"}
        ] },
      321 => ->(params, event){ [true,
        {color: :manage, text: sprintf(Vocab::Event::ModifyHeroClass, 
          Vocab::Event::hero_name(params[0]))},
        {color: :manage, text: Vocab::Event::class_name(params[1])}
        ] },
      322 => ->(params, event){ [true,
        {color: :system, text: sprintf(Vocab::Event::ModifyHeroAppearance, 
          Vocab::Event::hero_name(params[0]), *params[1..-1])}
        ] },
      323 => ->(params, event){ [true,
        {color: :system, text: sprintf(Vocab::Event::ModifyVehicleAppearance, 
          Vocab::Event::Vehicle[params[0]], *params[1..-1])},
        ] },
      324 => ->(params, event){ [true,
        {color: :manage, text: sprintf(Vocab::Event::ModifyHeroAlias,
          Vocab::Event::hero_name(params[0]))},
        {color: :manage, text: "'#{params[1]}'"}
        ] },
      331 => ->(params, event){ [true,
        {color: :battle, text: sprintf(Vocab::Event::ModifyHPEnemy, 
          Vocab::Event::foe_name(params[0], event))},
        {color: :battle, text: Vocab::Event::PlusOrMinus[params[1]]},
        {color: :battle, text: params[2] == 0 ? params[3].to_s : Vocab::Event::la_variable(params[3])}
        ] },
      332 => ->(params, event){ [true,
        {color: :battle, text: sprintf(Vocab::Event::ModifyMPEnemy, 
          Vocab::Event::foe_name(params[0], event))},
        {color: :battle, text: Vocab::Event::PlusOrMinus[params[1]]},
        {color: :battle, text: params[2] == 0 ? params[3].to_s : Vocab::Event::la_variable(params[3])}
        ] },
      333 => ->(params, event){ [true,
        {color: :battle, text: sprintf(Vocab::Event::ModifyStatusEnemy, 
          Vocab::Event::foe_name(params[0], event))},
        {color: :battle, text: Vocab::Event::PlusOrMinus[params[1]]},
        {color: :battle, text: Vocab::Event::state_name(params[2])}
        ] },
      334 => ->(params, event){ [true,
        {color: :battle, text: sprintf(Vocab::Event::RecoverEnemy, 
          Vocab::Event::foe_name(params[0], event))}
        ] },
      335 => ->(params, event){ [true,
        {color: :battle, text: sprintf(Vocab::Event::RevealEnemy, 
          Vocab::Event::foe_name(params[0], event))}
        ] },
      336 => ->(params, event){ [true,
        {color: :battle, text: sprintf(Vocab::Event::MorphEnemy, 
          Vocab::Event::foe_name(params[0], event), Vocab::Event::enemy_name(params[1]))}
        ] },
      337 => ->(params, event){ [true,
        {color: :battle, text: sprintf(Vocab::Event::DisplayBattleAnimation, 
          Vocab::Event::foe_name(params[0], event))},
        {color: :battle, text: Vocab::Event::animation_name(params[1])}
        ] },
      339 => ->(params, event){ [true,
        {color: :battle, text: sprintf(Vocab::Event::ForceAction, params[0] == 0 ? 
          Vocab::Event::foe_name(params[1], event) :  sprintf(Vocab::Event::Battler, params[1] + 1),
          Vocab::Event::skill_name(params[2]), Vocab::Event::target_name(params[3]))}        
      ]},
      340 => ->(params, event){ [true,
        {color: :battle, text: Vocab::Event::EndTheBattle}]},
      351 => ->(params, event){ [true,
        {color: :system, text: Vocab::Event::OpenMenu}]},
      352 => ->(params, event){ [true,
        {color: :system, text: Vocab::Event::OpenSave}]},
      353 => ->(params, event){ [true,
        {color: :system, text: Vocab::Event::GameOver}]},
      354 => ->(params, event){ [true,
        {color: :system, text: Vocab::Event::ToTitle}]},
      355 => ->(params, event){ [true,
        {color: :script, text: Vocab::Event::ScriptCall},
        {color: :script, text: params[0]}
        ] },
      401 => ->(params, event){ [false,
        {color: :nothing, text: Vocab::Event::Message[0...-2]}, # Without the ":" and space 
        {color: :standard, text: ":"},
        {color: :text, text: params[0]}] },
      402 => ->(params, event){ [false,
        {color: :standard, text: sprintf(Vocab::Event::Choice, "[#{params[1]}]")}] },
      403 => ->(params, event){ [false,
        {color: :standard, text: sprintf(Vocab::Event::Choice, Vocab::Event::CancelChoice)}] },
      404 => ->(params, event){ [false,
        {color: :standard, text: Vocab::Event::EndChoice}] },
      405 => ->(params, event){ [false,
        {color: :nothing, text: Vocab::Event::DisplayScrollingText[0...-2]},
        {color: :standard, text: ":"},
        {color: :text, text: params[0]}] },
      408 => ->(params, event){ [false,
        {color: :nothing, text: Vocab::Event::Comment[0...-2]},
        {color: :events, text: ":"},
        {color: :comments, text: params[0]}] },
      411 => ->(params, event){ [false,
        {color: :function, text: Vocab::Event::Else}] },
      412 => ->(params, event){ [false,
        {color: :function, text: Vocab::Event::EndCondition}] },
      413 => ->(params, event){ [false,
        {color: :function, text: Vocab::Event::EndLoop}] },
      505 => ->(params, event){ [false,
        {color: :nothing, text: Vocab::Event::MoveEvent[0...-2]},
        {color: :events, text: ":"},
        {color: :events, text: Vocab::Event::Command[2]},
        {color: :events, text: sprintf(Vocab::Event::MoveRouteCommands[params[0].code], 
            *params[0].to_params)}
        ]},
      601 => ->(params, event){ [false,
        {color: :function, text: Vocab::Event::IfVictory}] },
      602 => ->(params, event){ [false,
        {color: :function, text: Vocab::Event::IfFlee}] },
      603 => ->(params, event){ [false,
        {color: :function, text: Vocab::Event::IfLoss}] },
      604 => ->(params, event){ [false,
        {color: :function, text: Vocab::Event::EndBattle}] },
      605 => ->(params, event){ [false,
        {color: :nothing, text: Vocab::Event::Shop[0...-2]},
        {color: :game, text: ":"},
        {color: :game, text: Vocab::Event::base_item_name(*params[0..1])}
        ] },
      655 => ->(params, event){ [false,
        {color: :nothing, text: Vocab::Event::ScriptCall[0...-2]},
        {color: :script, text: ":"},
        {color: :script, text: params[0]}
        ] },
    }
    #--------------------------------------------------------------------------
    # * Converts params for variable operation
    #--------------------------------------------------------------------------
    OperandArray = [
      ->(params, event){params[0].to_s},
      ->(params, event){ 
        sprintf(Vocab::Event::ValueOfVariable, Vocab::Event::variable_name(params[0]))},
      ->(params, event){ 
        sprintf(Vocab::Event::RandomValue, params[0], params[1]) },
      ->(params, event){[
        ->(params, event){sprintf(Vocab::Event::NumberOf, Vocab::Event::item_name(params[0]))},
        ->(params, event){sprintf(Vocab::Event::NumberOf, Vocab::Event::weapon_name(params[0]))},
        ->(params, event){sprintf(Vocab::Event::NumberOf, Vocab::Event::armor_name(params[0]))},
        ->(params, event){sprintf("%s : %s", Vocab::Event::hero_name(params[0]),
          Vocab::Event::Attributes[params[1]])},
        ->(params, event){sprintf("%s : %s", Vocab::Event::foe_name(params[0], event), 
          Vocab::Event::Attributes[params[1]+2]) },
        ->(params, event){sprintf("%s : %s", Vocab::Event::event_name(params[0], event.map), 
          Vocab::Event::EventParam[params[1]]) },
        ->(params, event){sprintf(Vocab::Event::IdOfAMember, Vocab::Event::OrdinalNumber[params[0]])},
        ->(params, event){Vocab::Event::OtherVariable[params[0]] }
        ][params[0]].call(params[1..-1], event) },
      ->(params, event) {params[0]}
    ]
    #--------------------------------------------------------------------------
    # * Converts params for conditions
    #--------------------------------------------------------------------------
    ConditionArray = [
      ->(params, event){
        [Vocab::Event::Switch, Vocab::Event::switch_name(params[0]), 
            Vocab::Event::ComparationOperator[0], 
            Vocab::Event::OnOff[params[1]]].join(" ")
      },
      ->(params, event){
        [Vocab::Event::Variable, Vocab::Event::variable_name(params[0]), 
          Vocab::Event::ComparationOperator[params[3]],
          params[1] == 0 ? params[2].to_s : sprintf("%s %s", Vocab::Event::Variable,
            Vocab::Event::variable_name(params[2]))
        ].join(" ")
      },
      ->(params, event){
        [Vocab::Event::LocalSwitch, params[0],
          Vocab::Event::ComparationOperator[0],
          Vocab::Event::OnOff[params[1]]].join(" ")
      },
      ->(params, event){
        [Vocab::Event::LeChronometer, 
          sprintf(Vocab::Event::Start, params[0] / 60, params[0] % 60) ,
          Vocab::Event::MoreOrLess[params[1]] ].join(" ")
      },
      ->(params, event){
        [Vocab::Event::hero_name(params[0]),
          sprintf(Vocab::Event::HeroConditions[params[1]], HeroConditionString[params[1]].call(params[2]))       
        ].join(" ")
      },
      ->(params, event){ [Vocab::Event::foe_name(params[0], event),
          params[1] == 0 ? Vocab::Event::Present :
              sprintf(Vocab::Event::HeroConditions[5], Vocab::Event::state_name(params[2]))
        ].join(" ")
      },
      ->(params, event){
        [Vocab::Event::event_name(params[0], event.map), Vocab::Event::IsLooking,
        Vocab::Event::Direction[params[1]]].join(" ")
      },
      ->(params, event){
        sprintf(Vocab::Event::MoneyCondition, params[0], Vocab::Event::MoreOrLess[params[1]])
      },
      ->(params, event){
        sprintf(Vocab::Event::ItemCondition, Vocab::Event::item_name(params[0]))
      },
      ->(params, event){
        sprintf(Vocab::Event::WeaponCondition, Vocab::Event::weapon_name(params[0]), 
          params[1] ? Vocab::Event::OrEquipped : "")
      },
      ->(params, event){
        sprintf(Vocab::Event::ArmorCondition, Vocab::Event::armor_name(params[0]), 
          params[1] ? Vocab::Event::OrEquipped : "")
      },
      ->(params, event){
        sprintf(Vocab::Event::KeyCondition, Vocab::Event::Inputs[params[0]])
      },
      ->(params, event){
        sprintf(Vocab::Event::ScriptCondition, params[0])
      },
      ->(params, event){
        sprintf(Vocab::Event::VehicleCondition, Vocab::Event::Vehicle[params[0]])
      }
    ]
    #--------------------------------------------------------------------------
    # * Converts params for hero conditions
    #--------------------------------------------------------------------------
    HeroConditionString = [ ->(params){""},
        ->(params){ params.to_s },
        ->(params){ Vocab::Event::skill_name(params)},
        ->(params){ Vocab::Event::class_name(params)},
        ->(params){ Vocab::Event::weapon_name(params)},
        ->(params){ Vocab::Event::armor_name(params)},
        ->(params){ Vocab::Event::state_name(params)}
    ]
    #--------------------------------------------------------------------------
    # * Converts params for warp
    #--------------------------------------------------------------------------
    WarpText = [
      ->(params){ sprintf("[%03d:%s], (X:%03d, Y:%03d)", params[0], 
        Vocab::Event::map_name(params[0]), params[1], params[2]) },
      ->(params){ sprintf("ID:[%04d], X:[%04d], Y:[%04d]", *params) }
    ]
    #--------------------------------------------------------------------------
    # * Converts params for variable operation
    #--------------------------------------------------------------------------
    PositionArray = [
      ->(params, event){ sprintf(Vocab::Event::Position[0], *params)},
      ->(params, event){ sprintf(Vocab::Event::Position[1], *params)},
      ->(params, event){ sprintf(Vocab::Event::Position[2], 
        Vocab::Event::event_name(params[0], event.map))}
    ]
    #--------------------------------------------------------------------------
    # * Initialization
    #--------------------------------------------------------------------------
    def initialize(code = 0, indent = 0, parameters = [], event = nil)
      @code = code
      @indent = indent
      @parameters = parameters
      @event = event
      @parse_results = parse
      minimize
    end
    #--------------------------------------------------------------------------
    # * Add indent to representation
    #--------------------------------------------------------------------------
    def parse
       {:indent => @indent, :command => parse_command}
    end
    #--------------------------------------------------------------------------
    # * Parse command
    #--------------------------------------------------------------------------
    def parse_command
      CommandHash[@code].call(@parameters, @event)
    end
    #--------------------------------------------------------------------------
    # * From representation to raw
    #--------------------------------------------------------------------------
    def raw
      text = (@parse_results[:command][1..-1].map {|a| a[:text]}).join(" ")
      ((Vocab::Event::Command + " ") * (@parse_results[:indent] + 1)) + text
    end
    #--------------------------------------------------------------------------
    # * From representation to bbcode
    #--------------------------------------------------------------------------
    def bbcode
      start = sprintf("%s%s%s", 
        BBcode::colorize(:nothing, Vocab::Event::Command) * @parse_results[:indent], 
        BBcode::colorize(:standard, Vocab::Event::Command[0..1]),
        BBcode::colorize(
            @parse_results[:command].first ? :standard : :nothing, Vocab::Event::Command[2..2] << " "))
      text = (@parse_results[:command][1..-1].map do |hash|
        BBcode::colorize(hash[:color], hash[:text])
      end).join("")
      BBcode::line(start + text)
    end
    #--------------------------------------------------------------------------
    # * From representation to html
    #--------------------------------------------------------------------------
    def html
      start = sprintf("%s%s%s", 
        HTML::colorize(:nothing, Vocab::Event::Command) * @parse_results[:indent], 
        HTML::colorize(:standard, Vocab::Event::Command[0..1]),
        HTML::colorize(
            @parse_results[:command].first ? :standard : :nothing, Vocab::Event::Command[2..2] << " "))
      text = (@parse_results[:command][1..-1].map do |hash|
        HTML::colorize(hash[:color], hash[:text])
      end).join("")
      HTML::line(start + text)
    end
    #--------------------------------------------------------------------------
    # * Minimize representation (merge same color texts)
    #--------------------------------------------------------------------------
    def minimize
      return unless @parse_results[:command][2] 
      tab = [{color: @parse_results[:command][1][:color], text: ""}]
      @parse_results[:command][1..-1].each do |part|
        tab << {color: part[:color], text: ""} if tab.last[:color] != part[:color]
        tab.last[:text] << part[:text] << " "
      end
      @parse_results[:command][1..-1] = tab
    end
  end
  # End of Command  ------------------------------------------------------------------------------------------------
  #==============================================================================
  # ** EventPage
  #------------------------------------------------------------------------------
  #  Handle access to an event's page. 
  #==============================================================================
  class Page
    #--------------------------------------------------------------------------
    # * Public Instance Variables
    #--------------------------------------------------------------------------
    attr_reader :list
    #--------------------------------------------------------------------------
    # * Initialization
    #   ** list         list from a RPG::Event::Page list
    #   ** event     Event
    #--------------------------------------------------------------------------
    def initialize(list, event)
      @list = list.collect do |command|
        EventCommand.new(command.code, command.indent, command.parameters, event)
      end
      @event = event
    end
    #--------------------------------------------------------------------------
    # * Copy the raw conversion of commands
    #--------------------------------------------------------------------------
    def raw
      @list.map{|e| e.raw}.join("\n")
    end
    #--------------------------------------------------------------------------
    # * Copy the BBcode conversion of commands
    #--------------------------------------------------------------------------
    def bbcode
      str = BBcode::head(@event.printed_name)
      str << @list.map{ |e| e.bbcode }.join("\n")
      str << BBcode::foot
    end
    #--------------------------------------------------------------------------
    # * Copy the HTML conversion of commands
    #--------------------------------------------------------------------------
    def html
      str = HTML::head(@event.printed_name)
      str << @list.map{ |e| e.html }.join
      str << HTML::foot
    end
  end
  # End of Page  ------------------------------------------------------------------------------------------------
  #==============================================================================
  # ** Event
  #------------------------------------------------------------------------------
  #  Handle access to an event
  #==============================================================================
  class Event
    #--------------------------------------------------------------------------
    # * Public Instance Variables
    #--------------------------------------------------------------------------
    attr_reader :map
    attr_reader :pages
    attr_reader :troop
    #--------------------------------------------------------------------------
    # * Initialization
    #   ** event     Event
    #   ** map       RPG::Map
    #--------------------------------------------------------------------------
    def initialize(event, map)
      @id = event.id
      @name = event.name
      @event = event
      @map = map
      @troop ||= []
      @pages ||= @event.pages.collect do |page|
        Page.new(page.list, self)
      end
    end
    #--------------------------------------------------------------------------
    # * Build an event from its id and its map id
    #--------------------------------------------------------------------------
    def self.build(id_event, id_map)
      map = load_data(sprintf("Data/Map%03d.rvdata2", id_map))
      event = map.events[id_event]
      self.new(event, map)
    end
    #--------------------------------------------------------------------------
    # * Copy a page to raw format
    #--------------------------------------------------------------------------
    def raw(no_page = 0)
      @pages[no_page].raw
    end
    #--------------------------------------------------------------------------
    # * Copy a page to BBcode format
    #--------------------------------------------------------------------------
    def bbcode(no_page = 0)
      @pages[no_page].bbcode
    end
    #--------------------------------------------------------------------------
    # * Copy a page to HTML format
    #--------------------------------------------------------------------------
    def html(no_page = 0)
      @pages[no_page].html
    end
    #--------------------------------------------------------------------------
    # * String name
    #--------------------------------------------------------------------------
    def printed_name
      "Event - #{@name}"
    end
  end
  #==============================================================================
  # ** CommonEvent
  #------------------------------------------------------------------------------
  #  Handle access to a common event
  #==============================================================================
  class CommonEvent < Event
    #--------------------------------------------------------------------------
    # * Initialization
    #   ** event     Event
    #   ** map       RPG::Map
    #--------------------------------------------------------------------------
    def initialize(event, map)
      @map = map
      @pages = [Page.new(event.list, self)]
      super
    end
    #--------------------------------------------------------------------------
    # * Build an event from its id and its map id
    #--------------------------------------------------------------------------
    def self.build(id_event, id_map = 0)
      id_map = id_map == 0 ? DataManager.system.start_map_id : id_map
      map = load_data(sprintf("Data/Map%03d.rvdata2", id_map))
      event = load_data("Data/CommonEvents.rvdata2")[id_event]
      self.new(event, map)
    end
    #--------------------------------------------------------------------------
    # * String name
    #--------------------------------------------------------------------------
    def printed_name
      "CommonEvent - #{@name}"
    end
  end
  #==============================================================================
  # ** BattleEvent
  #------------------------------------------------------------------------------
  #  Handle access to a battle event
  #==============================================================================
  class BattleEvent < Event
    #--------------------------------------------------------------------------
    # * Initialization
    #   ** event     Event
    #   ** map       RPG::Map
    #--------------------------------------------------------------------------
    def initialize(event, map)
      @troop = event.members
      super
    end
    #--------------------------------------------------------------------------
    # * Build an event from its id and its map id
    #--------------------------------------------------------------------------
    def self.build(id_event, id_map = 0)
      map = load_data(sprintf("Data/Map%03d.rvdata2", id_map))
      event = load_data("Data/Troops.rvdata2")[id_event]
      self.new(event, map)
    end
    #--------------------------------------------------------------------------
    # * String name
    #--------------------------------------------------------------------------
    def printed_name
      "BattleEvent - #{@name}"
    end
  end
  # End of Event  ------------------------------------------------------------------------------------------------
  #==============================================================================
  # ** BBcode helper methods
  #==============================================================================
  module BBcode    
    #---------------------------------------------------------------------------------------------
    # * Public module methods
    #---------------------------------------------------------------------------------------------
    extend self
    #--------------------------------------------------------------------------
    # ** Head
    #--------------------------------------------------------------------------
    def head(string_name = "foo")
      sprintf("[table style='background-color:%s;border:1px solid; padding: 5px;text-shadow:none']%s", 
        Theme::Nothing, name(string_name))
    end
    #--------------------------------------------------------------------------
    # ** Name
    #--------------------------------------------------------------------------
    def name(string)
      sprintf("[b]%s[/b]", string)
    end
    #--------------------------------------------------------------------------
    # ** Colorization
    #--------------------------------------------------------------------------
    def colorize(color, string)
      sprintf("[color=%s]%s[/color]", Theme::get_color(color), string)
    end
    #--------------------------------------------------------------------------
    # ** Line
    #--------------------------------------------------------------------------
    def line(string)
      sprintf("[tr][td]%s[/td][/tr]", string)
    end        
    #--------------------------------------------------------------------------
    # ** Footer
    #--------------------------------------------------------------------------
    def foot
      "[/table]"
    end
  end
  #==============================================================================
  # ** HTML helper methods
  #==============================================================================
  module HTML    
    #---------------------------------------------------------------------------------------------
    # * Public module methods
    #---------------------------------------------------------------------------------------------
    extend self
    #--------------------------------------------------------------------------
    # ** Head
    #--------------------------------------------------------------------------
    def head(string_name = "foo")
      sprintf("%s<div style='background-color:%s; border: #94a4be 1px solid; padding: 5px;text-shadow:none>",
        name(string_name), Theme::Nothing)
    end
    #--------------------------------------------------------------------------
    # ** Name
    #--------------------------------------------------------------------------
    def name(string)
      sprintf("<span style='font-weight: bold; padding: 0px'\>%s</span>", string)
    end
    #--------------------------------------------------------------------------
    # ** Colorization
    #--------------------------------------------------------------------------
    def colorize(color, string)
      sprintf("<span style='color:%s'>%s</span>", Theme::get_color(color), string)
    end  
    #--------------------------------------------------------------------------
    # ** Line
    #--------------------------------------------------------------------------
    def line(string)
      sprintf("<p style='margin: 0'>%s</p>", string)
    end      
    #--------------------------------------------------------------------------
    # ** Footer
    #--------------------------------------------------------------------------
    def foot
      "</div>"
    end
  end
end

#==============================================================================
# ** Scene_Printer
#------------------------------------------------------------------------------
#  Main of the Event Printer
#==============================================================================

class Scene_Printer < Scene_Base
  #--------------------------------------------------------------------------
  # * Object Initialize
  #--------------------------------------------------------------------------
  def start
    super
    create_blank_bg
    create_title
    create_buttons
  end
  #--------------------------------------------------------------------------
  # * Create Title
  #--------------------------------------------------------------------------
  def create_title
    @title = GUI.create_title(Vocab.exp_event)
  end
  #--------------------------------------------------------------------------
  # * Create Buttons
  #--------------------------------------------------------------------------
  def create_buttons
    w = Graphics.width - 32
    @commons = Sprite.new
    @commons.x = 16
    @commons.y = 32
    @commons.bitmap = GUI.create_beveled_bitmap(w, 32)
    @commons.bitmap.draw_text(0,0,w,32, Vocab.commons_ev, 1)
    @commons.opacity = 200
    @battle = Sprite.new
    @battle.x = 16
    @battle.y = 70
    @battle.bitmap = GUI.create_beveled_bitmap(w, 32)
    @battle.bitmap.draw_text(0,0,w,32, Vocab.battle_ev, 1)
    @battle.opacity = 200
    @events = Sprite.new
    @events.x = 16
    @events.y = 110
    @events.bitmap = GUI.create_beveled_bitmap(w, 32)
    @events.bitmap.draw_text(0,0,w,32, Vocab.map_ev, 1)
    @events.opacity = 200
  end
  #--------------------------------------------------------------------------
  # * Update Processing
  #--------------------------------------------------------------------------
  def update
    super
    SceneManager.return if Keyboard.trigger?(:esc)
    [@commons,@battle,@events].each do |val|
      SceneManager.call(Scene_Printer_EC) if val.rect.trigger?(:mouse_left) && val == @commons
      val.opacity = (val.rect.hover?) ? 255 : 200
    end
  end
  #--------------------------------------------------------------------------
  # * Terminate
  #--------------------------------------------------------------------------
  def terminate
    super
    [@commons,@battle,@events].collect(&:dispose)
  end
end

#==============================================================================
# ** Scene_Printer_EC
#------------------------------------------------------------------------------
#  Main of the Event Printer Common Event
#==============================================================================

class Scene_Printer_EC < Scene_Base
  #--------------------------------------------------------------------------
  # * Object Initialize
  #--------------------------------------------------------------------------
  def start
    super
    @id = 1
    @ec = DataManager.common_events
    create_blank_bg
    create_title
    create_ec_list
    create_buttons
  end
  #--------------------------------------------------------------------------
  # * Create Title
  #--------------------------------------------------------------------------
  def create_title
    @title = GUI.create_title(Vocab.commons_ev)
  end
  #--------------------------------------------------------------------------
  # * Create Ec List
  #--------------------------------------------------------------------------
  def create_ec_list
    w = 2*(Graphics.width / 3)
    @viewport = GUI::Scrollable_Viewport.new(0, 16, w, Graphics.height-16)
    @sprites = Hash.new
    h = 18
    y = 2
    w = (y +  (@ec.compact.length * (18 + 2)) > Graphics.height-16) ? w - 20 : w - 4
    @ec.compact.each do |common|
      spr = Sprite.new(@viewport)
      t = (common.name.empty?) ? Vocab.no_title : common.name
      i = common.id
      spr.bitmap = GUI::create_box_bitmap(w, h, sprintf("%03d - %s", i, t), 10)
      spr.x, spr.y = 2, y
      y += 18 + 2
      @sprites[common.id] = spr
    end
  end
  #--------------------------------------------------------------------------
  # * create buttons
  #--------------------------------------------------------------------------
  def create_buttons
    @label = Sprite.new
    x = 2*(Graphics.width / 3) + 2
    y = 38
    w = (Graphics.width / 3) - 4
    h = 32
    @label.x, @label.y = x, y - 18
    @label.bitmap = GUI::create_blank_bitmap(w, h, "", 0, 1)
    @label.bitmap.draw_text(0,0,(Graphics.width / 3) - 4, 24, sprintf(Vocab.gen_common, @id), 1)
    @html = Sprite.new
    @html.x, @html.y = x, y
    @html.bitmap = GUI.create_beveled_bitmap(w, h)
    @html.bitmap.draw_text(0,0,w,32, Vocab.in_html, 1)
    @html.opacity = 200
    y += h+2
    @bbcode = Sprite.new
    @bbcode.x, @bbcode.y = x, y
    @bbcode.bitmap = GUI.create_beveled_bitmap(w, h)
    @bbcode.bitmap.draw_text(0,0,w,32, Vocab.in_bbcode, 1)
    @bbcode.opacity = 200
    y += h+2
    @code = Sprite.new
    @code.x, @code.y = x, y
    @code.bitmap = GUI.create_beveled_bitmap(w, h)
    @code.bitmap.draw_text(0,0,w,32, Vocab.in_code, 1)
    @code.opacity = 200
  end
  #--------------------------------------------------------------------------
  # * Update Processing
  #--------------------------------------------------------------------------
  def update
    super
    SceneManager.return if Keyboard.trigger?(:esc)
    [@html, @bbcode,  @code].each do |val|
      val.opacity = (val.rect.hover?) ? 255 : 200
      if val.rect.trigger?(:mouse_left)
        ec = EventPrinter::CommonEvent.build(@id)
        methd = case val 
        when @html; :html
        when @bbcode; :bbcode
        end
        Clipboard.push_text (ec.send(methd))
        msgbox("Mis dans le presse papier")
      end
    end
    @sprites.each do |k, v|
      if v.rect.trigger?(:mouse_left)
        @id = k
        @label.bitmap.clear 
        @label.bitmap.draw_text(0,0,(Graphics.width / 3) - 4, 24, sprintf(Vocab.gen_common, @id), 1)
      end
    end
    @viewport.update
  end
  #--------------------------------------------------------------------------
  # * Terminate
  #--------------------------------------------------------------------------
  def terminate
    super
    @viewport.dispose
  end
end