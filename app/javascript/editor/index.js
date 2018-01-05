import 'draft-js/dist/Draft.css'
import React, { Component } from 'react'
import {
  convertFromRaw,
  convertToRaw,
  ContentState,
  EditorState,
  RichUtils,
  Modifier,
  SelectionState,
} from 'draft-js'
import Editor from 'draft-js-plugins-editor'
import {
  createVariablePlugin,
  VARIABLE_ENTITY_TYPE,
} from './variable_plugin'
import { getEntities } from './utils'

let rawContent = {
  blocks: [
    {
      text: (
        'This is an "immutable" entity: <address>. Deleting any ' +
        'characters will delete the entire entity. Adding characters ' +
        'will remove the entity from the range.'
      ),
      type: 'unstyled',
      entityRanges: [{offset: 31, length: 9, key: 'first'}],
    },
    {
      text: (
        'This is an "immutable" entity: Superman. Deleting any ' +
        'characters will delete the entire entity. Adding characters ' +
        'will remove the entity from the range.'
      ),
      type: 'unstyled',
    },
  ],
  entityMap: {
    first: {
      type: VARIABLE_ENTITY_TYPE,
      mutability: 'IMMUTABLE',
      data: {
        name: 'address'
      }
    },
  },
}

class EditorInner extends Component {
  constructor(props) {
    super(props)

    const variablePlugin = createVariablePlugin()

    this.plugins = [
      variablePlugin,
    ]

    const blocks = convertFromRaw(rawContent)


    const editorState = EditorState.createWithContent(blocks)
    const contentState = editorState.getCurrentContent()


    const newEditorState = EditorState.set(editorState, {
      currentContent: contentState,
    })


    this.state = {
      editorState: newEditorState,
      nameValue: 'Facebook',
      addressValue: '1 Hacker Way, Menlo Park',
    }

    this.handleEvents()
  }

  handleEvents() {
    this.onChange = (editorState) => {
      this.setState({editorState})
    }

    this.insertVariable = (variableType) => {
      const { editorState } = this.state

      const selection = editorState.getSelection()

      if (selection.isCollapsed()) {
        const contentState = editorState.getCurrentContent()

        contentState.createEntity(
          VARIABLE_ENTITY_TYPE,
          'IMMUTABLE',
          {
            name: variableType,
          }
        )

        const entityKey = contentState.getLastCreatedEntityKey()
        const newContentState = Modifier.replaceText(
          contentState,
          selection,
          `<${variableType}>`,
          null,
          entityKey,
        )

        let newEditorState = EditorState.set(editorState, {
          currentContent: newContentState,
        })



        this.setState({
          editorState: newEditorState,
        })
      }
    }
  }

  handleReplace = () => {
    const { editorState } = this.state
    const contentState = editorState.getCurrentContent()

    let newContentState = contentState

    const entities = getEntities(newContentState)

    for (let i = 0; i < entities.length; i++) {
      const entity = getEntities(newContentState)[i]
      const block = contentState.getBlockForKey(entity.blockKey)

      let selection = SelectionState.createEmpty(block.getKey())
      selection = selection.merge({
        anchorOffset: entity.start,
        focusOffset: entity.end,
      })


      const variableName = entity.entity.getData().name
      let replacedText = ''

      switch (variableName) {
        case 'name':
          replacedText = this.state.nameValue
          break
        case 'address':
          replacedText = this.state.addressValue
          break
        default:
          replacedText = ''
      }

      newContentState = Modifier.replaceText(
        newContentState,
        selection,
        replacedText,
        null,
        entity.entityKey
      )
    }

    let newEditorState = EditorState.set(editorState, {
      currentContent: newContentState,
    })
    this.setState({
      editorState: newEditorState,
    })
  }

  handleFormChange = (e) => {
    this.setState({
      [e.target.name]: e.target.value,
    })
  }

  render() {
    return (
      <div>
        <div className="row">
          <div className="col-sm-6">
            <table className="table">
              <tbody>
              <tr>
                <td>
                  <span className="name-variable" onClick={() => { this.insertVariable('name') }}>Name</span>
                </td>
                <td>
                  <input
                    name="nameValue"
                    value={this.state.nameValue}
                    onChange={this.handleFormChange}
                    type="text"
                    className="form-control form-control-sm"
                  />
                </td>
              </tr>
              <tr>
                <td>
                  <span className="address-variable" onClick={() => { this.insertVariable('address') }}>Address</span>
                </td>
                <td>
                  <input
                    name="addressValue"
                    value={this.state.addressValue}
                    onChange={this.handleFormChange}
                    type="text"
                    className="form-control form-control-sm"
                  />
                </td>
              </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div className="btn-group btn-group-sm mb-1">
          <button type="button" className="btn btn-outline-primary" onClick={this.handleReplace}>Replace text</button>
        </div>
        <div className="editor-wrapper">
          <Editor
            editorState={this.state.editorState}
            onChange={this.onChange}
            plugins={this.plugins}
            placeholder="Write down something..."
          />
        </div>
        <hr/>
        <pre>{JSON.stringify(convertToRaw(this.state.editorState.getCurrentContent()), null, 2)}</pre>
      </div>
    )
  }
}

class ArticleEditor extends React.Component {

  render() {
    return (
      <div className="container mt-4">
        <EditorInner/>
      </div>
    )
  }
}

export const EditorPage = ArticleEditor
