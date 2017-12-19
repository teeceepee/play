import 'draft-js/dist/Draft.css'
import React from 'react'
import {
  convertFromRaw,
  convertToRaw,
  CompositeDecorator,
  ContentState,
  Editor,
  EditorState,
  RichUtils,
  Modifier,
  SelectionState,
} from 'draft-js'
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
      type: 'ADDRESS',
      mutability: 'IMMUTABLE',
    },
  },
};

function getEntityStrategy(mutability) {
  return function(contentBlock, callback, contentState) {
    contentBlock.findEntityRanges(
      (character) => {
        const entityKey = character.getEntity();
        if (entityKey === null) {
          return false;
        }
        return contentState.getEntity(entityKey).getMutability() === mutability;
      },
      callback
    );
  };
}


class TokenSpan extends React.Component {

  render() {
    const { offsetkey, children, contentState, entityKey } = this.props
    const entity = contentState.getEntity(entityKey)

    const cls = `${entity.getType().toLowerCase()}-token`
    return (
      <span data-offset-key={offsetkey} className={cls} >{children}</span>
    )
  }
}

class EditorInner extends React.Component {
  constructor(props) {
    super(props)

    const decorator = new CompositeDecorator([
      {
        strategy: getEntityStrategy('IMMUTABLE'),
        component: TokenSpan,
      },
    ])

    const blocks = convertFromRaw(rawContent)


    const editorState = EditorState.createWithContent(blocks, decorator)
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

    this.insertVariable = (entityType) => {
      const { editorState } = this.state

      const selection = editorState.getSelection()

      if (selection.isCollapsed()) {
        const contentState = editorState.getCurrentContent()

        contentState.createEntity(
          entityType.toUpperCase(),
          'IMMUTABLE',
        )

        const entityKey = contentState.getLastCreatedEntityKey()
        const newContentState = Modifier.replaceText(
          contentState,
          selection,
          `<${entityType}>`,
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


      let replacedText = ''

      if (entity.entity.getType() === 'NAME') {
        replacedText = this.state.nameValue
      } else if (entity.entity.getType() === 'ADDRESS') {
        replacedText = this.state.addressValue
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
                  <span className="name-token" onClick={() => { this.insertVariable('name') }}>Name</span>
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
                  <span className="address-token" onClick={() => { this.insertVariable('address') }}>Address</span>
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
        <Editor editorState={this.state.editorState} onChange={this.onChange} />
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
